#include <iostream>
#include <vector>
#include <unordered_map>
#include <algorithm>

using namespace std;

class F {
public:
    using value_type = pair<int, string>;

    bool operator()(value_type const& lhs, value_type const& rhs) {
        if (lhs.first > rhs.first) return true;
        if (lhs.first == rhs.first && lhs.second < rhs.second) return true;
        return false;
    }
};

int main() {
    unordered_map<string, int> m;
    string s;
    ios_base::sync_with_stdio(false);
    cin.tie(nullptr);
    while (cin >> s) {
        ++m[s];
    }
    vector<pair<int, string>> mvec;
    for (const auto& p: m) {
        mvec.emplace_back(p.second, p.first);
    }
    sort(mvec.begin(), mvec.end(), F());
    for (const auto& p: mvec) {
        cout << p.second << "\t" << p.first << "\n";
    }

}
