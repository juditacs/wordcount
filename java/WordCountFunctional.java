import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Arrays;
import java.util.Comparator;
import java.util.Map;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

/**
 * Slow but "functional" Java 8 stream version. Maybe someone can do this without
 * intermediate collecting to HashMap and inlining the Comparators.
 * I wonder how the memory behaves with this one.
 * Based on: http://stackoverflow.com/questions/29122394/word-frequency-count-java-8
 */
class WordCountFunctional {
	public static void main(String[] args) throws IOException {
		BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
		Pattern p = Pattern.compile("\\s+");
		
		Map<String, Integer> words = br.lines()
				.map(line -> p.split(line))
                .flatMap(Arrays::stream)
                .filter(line -> !line.isEmpty())
				.collect(Collectors.toMap(w -> w, w -> 1, Integer::sum)); // toConcurrentMap
		
	    final Comparator<Map.Entry<String, Integer>> byValueReverse = Comparator.comparing(Map.Entry::getValue, Comparator.reverseOrder());
	    final Comparator<Map.Entry<String, Integer>> byKey = Comparator.comparing(Map.Entry::getKey);
		
		words.entrySet().stream()
				.sorted(byValueReverse.thenComparing(byKey))
				.forEach(entry -> System.out.println(entry.getKey() + "\t" + entry.getValue()));
	}
}
