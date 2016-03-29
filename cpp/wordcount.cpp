#include <iostream>
#include <vector>
#include <tuple>
#include <unordered_map>
#include <algorithm>

using namespace std;

int main() {
    unordered_map<string, int> m;
    m.max_load_factor(0.5);
    string s;
    ios_base::sync_with_stdio(false);
    cin.tie(nullptr);
    while (cin >> s) {
        --m[s];
    }
    vector<tuple<int, string>> mvec;
    mvec.reserve(m.size());
    for (auto& p: m) {
        mvec.emplace_back(p.second, move(p.first));
    }
    sort(mvec.begin(), mvec.end());
    for (const auto& p: mvec) {
        cout << get<1>(p) << "\t" << -get<0>(p) << "\n";
    }

}
