#include <iostream>
#include <map>
#include <unordered_map>
#include <set>


class F {
public:
    bool operator()(std::pair<int, std::string> lhs, std::pair<int, std::string> rhs) {
        if (lhs.first > rhs.first) return true;
        if (lhs.first == rhs.first && lhs.second < rhs.second) return true;
        return false;
    }
};

int main() {
    std::unordered_map<std::string, int> m;
    std::string s;
    while (std::cin >> s) {
        ++m[s];
    }
    std::multiset<std::pair<int, std::string>, F> mm;
    for (auto p: m) mm.insert(std::pair<int, std::string>{p.second, p.first});
    for (auto p: mm) {
        std::cout << p.second << "\t" << p.first << std::endl;
        printf("%d\t%s\n", p.first, p.second.c_str());
    }

}
