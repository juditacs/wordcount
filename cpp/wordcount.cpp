#include <stdio.h>
#include <vector>
#include <unordered_map>
#include <algorithm>
#include <string>

typedef std::unordered_map<std::string, size_t> Hash;
typedef Hash::value_type Entry;

#define MAX_WORD_LENGTH 1024
char word[MAX_WORD_LENGTH];

int main() {
	Hash m;

	char format[MAX_WORD_LENGTH];
	sprintf(format, "%%%ds", MAX_WORD_LENGTH - 1);

	while (scanf(format, word) == 1)
		++m[word];

	std::vector<const Entry*> mvec(m.size());
	std::transform(m.begin(), m.end(), mvec.begin(), [](const Entry& original){return &original;});
	std::sort(mvec.begin(), mvec.end(),
		[](const Entry*& left, const Entry*& right)
		{
			return (left->second > right->second||
				(!(right->second > left->second ) && left->first < right->first));
		});
	for (auto p: mvec)
		printf("%s\t%u\n", p->first.c_str(), p->second);

	return 0;
}
