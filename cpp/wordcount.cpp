#include <algorithm>
#include <iostream>
#include <memory>
#include <tuple>
#include <unordered_map>

struct word_freq {
	std::string const* word;
	int                freq;
};

int main() {
	std::ios_base::sync_with_stdio(false);
	std::cin.tie(nullptr);

	std::unordered_map<std::string, int> m;
	m.max_load_factor(0.5);
	std::string s;
	while (std::cin >> s) {
		++m[s];
	}

	auto const size = m.size();
	std::unique_ptr<word_freq[]> v(new word_freq[size]);
	std::transform(m.begin(), m.end(), v.get(), [](auto const& p){
		return word_freq{&p.first, p.second};
	});

	auto const v_end = v.get() + size;
	std::sort(v.get(), v_end, [](auto const& l, auto const& r){
		return std::tie(r.freq, *l.word) < std::tie(l.freq, *r.word);
	});

	for (auto wf = v.get(); wf != v_end; ++wf) {
		std::cout << wf->freq << "\t" << *wf->word << "\n";
	}
}
