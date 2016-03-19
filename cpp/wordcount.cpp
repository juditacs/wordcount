#include <iostream>
#include <vector>
#include <unordered_map>
#include <algorithm>
#include <string>

typedef std::unordered_map<std::string, size_t> Hash;
typedef std::pair<std::string, size_t> Entry;

int main() {
	Hash m;
    std::string s;
    std::ios_base::sync_with_stdio(false);
    std::cin.tie(nullptr);
	std::cout.tie(nullptr);
    while (std::cin >> s) {
        ++m[s];
    }
	std::vector<Entry> mvec(m.begin(), m.end());
    std::sort(mvec.begin(), mvec.end(),
		[](const Entry& left, const Entry& right)
	{
		return (left.second > right.second||
			(!(right.second > left.second ) && left.first < right.first));
	});
    for (auto p: mvec) {
        std::cout << p.first << "\t" << p.second << "\n";
    }

}
