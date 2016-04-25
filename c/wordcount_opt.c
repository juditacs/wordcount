#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <unistd.h>
#include <sys/mman.h>
#include <errno.h>
#include <nmmintrin.h>
#include <string.h>

#define TABLE_SIZE       (1L << 27) // Main hash table entries.
#define ENTRIES_MAX_SIZE (1L << 27) // Max number of distinct words.
#define NODE_AREA_SIZE   (1L << 32) // Virtual memory area for nodes.
#define IO_CHUNKS        1024       // Number of SSE registers in stdin read.

struct node {
	int32_t count;
	int32_t key_length;
	struct node *next;
	uint8_t key[] __attribute__((aligned(16))); // SSE load.
};

static struct node **htable;
static struct node **entries;
static int64_t entry_offset = 0;

static void *node_mem;
static int64_t node_mem_offset = 0;

static uint8_t excess_io_bytes[1024 * 1024]; // 1M character word limit.

static void * virt_alloc(size_t size)
{
	void *ptr = mmap(NULL, size,
			PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, 0, 0);
	if (ptr == MAP_FAILED) {
		fprintf(stderr, "mmap failed: %d\n", errno);
		exit(EXIT_FAILURE);
	}
	return ptr;
}

static void insert_key(uint8_t *key, int length)
{
	uint32_t hash = 0;

	for (int i=0; i != length; i++)
		hash = hash * 33 + key[i];

	struct node **pptr = &htable[hash & (TABLE_SIZE - 1)];
	for (; *pptr; pptr = &(*pptr)->next) { // Search fallback linked list.
		struct node *ptr = *pptr;
		if (ptr->key_length != length)
			continue;
		if (!memcmp(ptr->key, key, length)) { // Found duplicate.
			ptr->count++;
			return;
		}
	}
	struct node *new = &node_mem[node_mem_offset];
	node_mem_offset += (sizeof(struct node) + length + 1 + 15) & ~15;
	new->count = 1;
	new->key_length = length;
	new->next = NULL;
	memcpy(new->key, key, length);

	// Add NULL termination to ensure correct comparison when one key
	// is a prefix of the compared key.
	new->key[length] = '\0';
	*pptr = new;
	entries[entry_offset++] = new;
}

static int compare(const void *aptr, const void *bptr)
{
	const struct node *a = *(const struct node **)aptr;
	const struct node *b = *(const struct node **)bptr;

	if (a->count != b->count)
		return b->count - a->count;

	__m128i *apacked = (__m128i *)&a->key;
	__m128i *bpacked = (__m128i *)&b->key;

	int alen = a->key_length;
	int blen = b->key_length;

	for (int i=0; ; i++) {
		int idx = _mm_cmpestri(apacked[i], alen, bpacked[i], blen,
					_SIDD_CMP_EQUAL_EACH | _SIDD_NEGATIVE_POLARITY);
		if (idx < 16) {
			int abs = i * 16 + idx;
			return (int)a->key[abs] - (int)b->key[abs];
		}
		alen -= 16;
		blen -= 16;
	}
}

static void parse_input(void)
{
	__m128i separators = _mm_loadu_si128((__m128i *)"\t\n ");
	uint8_t buffer[IO_CHUNKS * 16];
	int n, excess = 0;

	do {
		int start = 0;
		n = read(STDIN_FILENO, buffer, sizeof(buffer));
		if (n < sizeof(buffer))
			memset(&buffer[n], ' ', sizeof(buffer) - n);

		for (int c=0; c != IO_CHUNKS; c++) {
			uint16_t mask = _mm_cvtsi128_si32(_mm_cmpestrm(separators, 3,
					((__m128i *)buffer)[c], 16, 0));
			if (!mask)
				continue;

			if (excess) { // Use the word in the excess buffer before moving on.
				int split = __builtin_ctz(mask);
				int acc = c * 16 + split;
				memcpy(&excess_io_bytes[excess], buffer, acc);
				insert_key(excess_io_bytes, excess + acc);
				start = acc + 1;
				mask &= ~(1 << split);
				excess = 0;
			}

			int index = c * 16;
			while (mask) { // Find the separators in the 16 byte chunk.
				int bit = __builtin_ctz(mask);
				index += bit;
				if (start != index)
					insert_key(&buffer[start], index - start);
				start = ++index;
				mask >>= bit + 1;
			}
		}
		if (start < n) { // Move rest to excess.
			memcpy(&excess_io_bytes[excess], &buffer[start], n - start);
			excess += n - start;
		}
	} while (n == sizeof(buffer));

	if (excess) // Rare case when the last word touches the end of the buffer.
		insert_key(excess_io_bytes, excess);
}

int main(int argc, char *argv[])
{
	char info[64];
	int info_length, prev_count = -1;

	htable = calloc(TABLE_SIZE, sizeof(*htable));
	entries = virt_alloc(sizeof(*entries) * ENTRIES_MAX_SIZE);
	node_mem = virt_alloc(NODE_AREA_SIZE);

	if ((uintptr_t)node_mem % 16) {
		fprintf(stderr, "Node memory not aligned to 16 bytes.\n");
		exit(EXIT_FAILURE);
	}
	parse_input(); // Parse and insert.
	qsort(entries, entry_offset, sizeof(*entries), compare);

	for (int i=0; i != entry_offset; i++) {
		struct node *ptr = entries[i];

		if (ptr->count != prev_count) {
			info_length = sprintf(info, "\t%d\n", ptr->count);
			prev_count = ptr->count;
		}
		fwrite(ptr->key, 1, ptr->key_length, stdout);
		fwrite(info, 1, info_length,  stdout);
	}
	return EXIT_SUCCESS;
}

