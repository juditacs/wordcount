#include <iostream>
#include <vector>
#include <unordered_map>
#include <algorithm>


class F {
public:
    bool operator()(std::pair<int, std::string> const& lhs, std::pair<int, std::string> const& rhs) {
        if (lhs.first > rhs.first) return true;
        if (lhs.first == rhs.first && lhs.second < rhs.second) return true;
        return false;
    }
};

int main() {
    std::unordered_map<std::string, int> m;
    std::string s;
    std::ios_base::sync_with_stdio(false);
    while (std::cin >> s) {
        ++m[s];
    }
    std::vector<std::pair<int, std::string>> mvec;
    for (auto p: m) mvec.push_back(std::pair<int, std::string>{p.second, p.first});
    std::sort(mvec.begin(), mvec.end(), F());
    for (auto p: mvec) {
        std::cout << p.second << "\t" << p.first << std::endl;
    }

}
