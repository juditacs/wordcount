#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifndef MAX_WORD_LENGTH
#	define MAX_WORD_LENGTH 1000
#endif

size_t hash_function(const char* str, size_t len)
{
	size_t h = 0,i;
	for (i = 0; i < len; i += sizeof(size_t))
	{
		h += *((size_t*)(str + i)); //modulo is taken via unsigned integer overflow!
	}
	return h;
}

typedef struct REC
{
	char* str;
	size_t count;
} hash_rec;

size_t hash_table_size = 4096, actual_hash_size = 0;
hash_rec* hash_table;
double rehash_constant = 0.8f;
double expand_constant = 1.5f;

void rehash()
{
	hash_rec* what, *new_place;
	const size_t new_table_size = (size_t)(expand_constant*hash_table_size);
	size_t new_hash_val;
	hash_rec* new_table = calloc(new_table_size, sizeof(hash_rec));

	if (new_table == NULL)
		exit(1);
	for (what = hash_table; what < hash_table + hash_table_size; ++what)
		if (what->str)
		{
			new_hash_val = hash_function(what->str, strlen(what->str)) % new_table_size;
			for (new_place = new_table + new_hash_val; new_place < new_table + new_table_size; ++new_place)
			{
				if (new_place->str == NULL)
				{
					*new_place = *what;
					break;
				}
			}
			if (new_place == new_table + new_table_size) // start from the beginning
				for (new_place = new_table; new_place < new_table + new_hash_val; ++new_place)
				{
					if (new_place->str == NULL)
					{
						*new_place = *what;
						break;
					}
				}
		}
	hash_table_size = new_table_size;
	free(hash_table);
	hash_table = new_table;
}

void hash_insert(const char* str, size_t len)
{
	size_t hash_val = hash_function(str, len) % hash_table_size;
	hash_rec* where;
	for (where = hash_table + hash_val; where < hash_table + hash_table_size; ++where)
	{
		if (where->str == NULL)
		{
			where->str = calloc(len + sizeof(size_t), sizeof(char));
			memcpy(where->str, str, len + sizeof(size_t));
			where->count = 1;
			++actual_hash_size;
			return;
		}
		else if (strcmp(where->str, str) == 0)
		{
			++(where->count);
			return;
		}
	}
	for (where = hash_table; where < hash_table + hash_val; ++where)
	{
		// try the same from the beginning
		if (where->str == NULL)
		{
			where->str = calloc(len + sizeof(size_t), sizeof(char));
			memcpy(where->str, str, len + sizeof(size_t));
			where->count = 1;
			++actual_hash_size;
			return;
		}
		else if (strcmp(where->str, str) == 0)
		{
			++(where->count);
			return;
		}
	}
}

int comparator(const void* left, const void* right)
{
	return ((*(hash_rec**)left)->count > (*(hash_rec**)right)->count) ? -1 : (((*(hash_rec**)left)->count == (*(hash_rec**)right)->count) ? strcmp((*(hash_rec**)left)->str, (*(hash_rec**)right)->str) : 1);
}

int main(int argc, char* argv[])
{
	char word[MAX_WORD_LENGTH + sizeof(size_t)];
	char input_format[MAX_WORD_LENGTH];
	const char* output_format = (sizeof(size_t) == sizeof(long long) ? "%s\t%llu\n" : "%s\t%u\n");

	size_t len;
	hash_rec* hash_ptr, **sorted_table;
	char* const program_name = argv[0];

	for (++argv; *argv; ++argv)
	{
		if (strcmp("-h", *argv) == 0 || strcmp("--help", *argv) == 0)
		{
			printf("Simple word counting application, author: borbely@math.bme.hu\nUSAGE: %s [options] < your.favorite.text.txt > words.and.counts.txt\n", program_name);
			printf("Maximum word length is %d!\n", MAX_WORD_LENGTH);
			printf("\t-h --help\tshow this help and exit\n");
			printf("\t-r --rehash\tdetermines the fraction above which a rehash is performed, default %g\n", rehash_constant);
			printf("\t-e --expand\tthe fraction determining how much more space is allocated during a rehash, default %g\n", expand_constant);
			printf("\t-n --initial\tinitial hash table size, default %d\n", (int)hash_table_size);
			exit(0);
		}
		else if (strcmp("-r", *argv) == 0 || strcmp("--rehash", *argv) == 0)
		{
			rehash_constant = atof(*++argv);
			rehash_constant = rehash_constant < 1.0 && rehash_constant > 0.0 ? rehash_constant : 0.8;
		}
		else if (strcmp("-e", *argv) == 0 || strcmp("--expand", *argv) == 0)
		{
			expand_constant = atof(*++argv);
			expand_constant = expand_constant > 1.0 ? expand_constant: 1.5;
		}
		else if (strcmp("-n", *argv) == 0 || strcmp("--initial", *argv) == 0)
		{
			hash_table_size = atoi(*++argv) < 1 ? 1 : (size_t)atoi(*argv);
		}
	}

	hash_table = calloc(hash_table_size, sizeof(hash_rec));
	
	sprintf(input_format, "%%%ds", MAX_WORD_LENGTH);

	while (scanf(input_format, word) == 1)
	{
		len = strlen(word);
		*((size_t*)(word + len)) = 0;
		hash_insert(word, len);
		if (actual_hash_size > rehash_constant*hash_table_size)
			rehash();
	}

	sorted_table = malloc(actual_hash_size*sizeof(hash_rec*));
	if (sorted_table == NULL)
		exit(1);
	len = 0;
	for (hash_ptr = hash_table; hash_ptr < hash_table + hash_table_size; ++hash_ptr)
	{
		if (hash_ptr->str)
			sorted_table[len++] = hash_ptr;
	}
	qsort(sorted_table, actual_hash_size, sizeof(hash_rec*), comparator);

	for (len = 0; len < actual_hash_size; ++len)
		printf(output_format, sorted_table[len]->str, sorted_table[len]->count);

	return 0;
}
