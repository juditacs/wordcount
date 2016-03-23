import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.regex.Pattern;

import it.unimi.dsi.fastutil.objects.Object2IntMap;
import it.unimi.dsi.fastutil.objects.Object2IntOpenHashMap;
import it.unimi.dsi.fastutil.objects.ObjectArrayList;
import it.unimi.dsi.fastutil.objects.ObjectArrays;

public class WordCountFastUtil {
	
	public static void main(String[] args) throws IOException {
		Pattern p = Pattern.compile("\\s+");
		
		int maxCount = 1;
		
		Object2IntMap<String> words = new Object2IntOpenHashMap<>(2_000_000); // Init capacity needs testing
		
		BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
		String line;
		while ((line = br.readLine()) != null) {
			line = line.trim();
			if (!line.isEmpty()) {
				for (String word : p.split(line)) {
					int count = words.containsKey(word) ? words.get(word) + 1 : 1;
					words.put(word, count);
					maxCount = Math.max(maxCount, count);
				}
			}
		}
		
		// System.err.println("Reading complete. maxCount: " + maxCount);

		@SuppressWarnings("unchecked")
		ObjectArrayList<String>[] counts = new ObjectArrayList[maxCount];
		
		for (String word : words.keySet()) {
			int count = words.get(word);
			ObjectArrayList<String> lst = counts[count - 1];
			if (lst == null) {
				lst = new ObjectArrayList<String>();
				counts[count - 1] = lst;
			}
			lst.add(word);
		}
		
		// System.err.println("Shuffling complete");
		
		for (int count = counts.length; count > 0; count--) {
			ObjectArrayList<String> lst = counts[count - 1];
			if(lst == null) continue;
			Object[] arr = counts[count - 1].toArray();
			ObjectArrays.parallelQuickSort(arr); // Try other sorting algorithms
			for (Object word : arr) {
				System.out.println(word + "\t" + count);
			}
		}
		
	}

}
