import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

/**
 * Based on DavidNemeskey's version. HashMap should be more efficient than TreeMap.
 * Word count for Java. Slow because of boxing/unboxing.
 */
class WordCount {
    public static void main(String[] args) throws IOException {
        		BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
		Pattern p = Pattern.compile("\\s+");
		Map<String, Integer> words = new HashMap<>();
		String line;
		while ((line = br.readLine()) != null) {
			line = line.trim();
			if (!line.isEmpty()) {
				for (String word : p.split(line)) {
					words.put(word, words.containsKey(word) ? words.get(word) + 1 : 1);
				}
			}
		}
		
		Map<Integer, ArrayList<String>> counts = new HashMap<>();
		for (String word : words.keySet()) {
			int count = words.get(word);
			ArrayList<String> lst = counts.get(count);
			if (lst == null) {
				lst = new ArrayList<String>();
				counts.put(count, lst);
			}
			lst.add(word);
		}
		
		ArrayList<Integer> countsKeys = new ArrayList<>(counts.keySet());
		Collections.sort(countsKeys, Collections.reverseOrder());
		for (int count : countsKeys) {
			List<String> lst = counts.get(count);
			Collections.sort(lst);
			for (String word : lst) {
				System.out.println(word + "\t" + count);
			}
		}
    }
}
