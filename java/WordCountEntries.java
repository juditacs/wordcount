import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import java.util.Collections;
import java.util.Comparator;
import java.util.regex.Pattern;

class WordCountEntries {
    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        Map<String, Integer> m = new HashMap<String, Integer>();
        Pattern p = Pattern.compile("\\s+");
        String line;
        while ((line = br.readLine()) != null) {
            line = line.trim();
            if (!line.isEmpty()) {
                for (String word : p.split(line)) {
                    m.put(word, m.containsKey(word) ? m.get(word) + 1 : 1);
                }
            }
        }

        List<Map.Entry<String, Integer>> lst =
                new ArrayList<Map.Entry<String, Integer>>(m.entrySet());
        Collections.sort(lst, new Comparator<Map.Entry<String, Integer>>() {
            public int compare(Map.Entry<String, Integer> o1,
                               Map.Entry<String, Integer> o2) {
                if (o1.getValue() < o2.getValue()) {
                    return 1;
                } else if (o1.getValue() > o2.getValue()) {
                    return -1;
                } else {
                    return o1.getKey().compareTo(o2.getKey());
                }
            }
        });

        for (Map.Entry<String, Integer> e : lst) {
            System.out.println(e.getKey() + "\t" + e.getValue());
        }
    }
}
