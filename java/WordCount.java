import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.NavigableMap;
import java.util.StringTokenizer;
import java.util.TreeMap;

/** Word count for Java. Slow because of boxing/unboxing. */
class WordCount {
    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        Map<String, Integer> m = new LinkedHashMap<String, Integer>();
        String line;
        while ((line = br.readLine()) != null) {
            StringTokenizer st = new StringTokenizer(line);

            while (st.hasMoreTokens()) {
                String word = st.nextToken();
                m.put(word, m.containsKey(word) ? m.get(word) + 1 : 1);
            }
        }

        NavigableMap<Integer, List<String>> mm = new TreeMap<Integer, List<String>>();
        for (Entry<String, Integer> entry : m.entrySet()) {
            Integer count = entry.getValue();
            List<String> lst = mm.get(count);
            if (lst == null) {
                lst = new ArrayList<String>();
                mm.put(count, lst);
            }
            lst.add(entry.getKey());
        }

        StringBuilder sb = new StringBuilder();
        for (Entry<Integer, List<String>> entry : mm.descendingMap().entrySet()) {
            List<String> lst = entry.getValue();
            Collections.sort(lst);
            for (String word : lst) {
                sb.append(word).append("\t").append(entry.getKey()).append(System.lineSeparator());
            }
        }
        System.out.print(sb);
    }
}
