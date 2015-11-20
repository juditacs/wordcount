import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import java.util.NavigableMap;
import java.util.TreeMap;
import java.util.Collections;

class WordCount {
    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        Map<String, Integer> m = new HashMap<String, Integer>();
        String line;
        while ((line = br.readLine()) != null) {
            for (String word : line.split("\\s"))
                m.put(word, m.containsKey(word) ? m.get(word) + 1 : 1);
        }

        NavigableMap<Integer, List<String>> mm = new TreeMap<Integer, List<String>>();
        for (String word : m.keySet()) {
            Integer count = m.get(word);
            List<String> lst = mm.get(count);
            if (lst == null) {
                lst = new ArrayList<String>();
                mm.put(count, lst);
            }
            lst.add(word);
        }

        for (Integer count : mm.descendingKeySet()) {
            List<String> lst = mm.get(count);
            Collections.sort(lst);
            for (String word : lst) {
                System.out.println(word + "\t" + count);
            }
        }
    }
}
