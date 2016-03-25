import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.OutputStreamWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import java.util.Collections;

/**
 * Word count for Java. Slow because of boxing/unboxing.
 */
class WordCountArray {

    private static class CountForWord implements Comparable<CountForWord> {

        String word;
        int count = 1;

        public CountForWord(String word) {
            this.word = word;
        }

        @Override
        public int compareTo(CountForWord t) {
            if (count < t.count) {
                return 1;
            } else if (count > t.count) {
                return -1;
            } else {
                return word.compareTo(t.word);
            }
        }
    }

    private static int submitWord(Map<String, CountForWord> m, String word) {
        CountForWord c;
        if ((c = m.get(word)) != null) {
            c.count++;
        } else {
            m.put(word, c = new CountForWord(word));
        }
        return c.count;
    }

    public static void main(String[] args) throws IOException {
        int maxCount = 0;
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        Map<String, CountForWord> m = new HashMap<String, CountForWord>();
        String line;
        while ((line = br.readLine()) != null) {
            line = line.trim();
            if (!line.isEmpty()) {
                int index = 0;
                for (int i = 0; i < line.length(); i++) {
                    char c = line.charAt(i);
                    if (c == '\t' || c == ' ') {
                        if (index == i) {
                            index++;
                        } else {
                            String word = line.substring(index, i);
                            index = i + 1;
                            int count = submitWord(m, word);
                            maxCount = Math.max(count, maxCount);
                        }
                    }
                }
                if (index < line.length()) {
                    int count = submitWord(m, line.substring(index));
                    maxCount = Math.max(count, maxCount);
                }
            }
        }
        br.close();

        System.err.println("sorting...");

        ArrayList<String>[] groupedByCount = new ArrayList[maxCount];
        for (CountForWord c : m.values()) {
            if (groupedByCount[c.count] == null) {
                groupedByCount[c.count] = new ArrayList<String>();
                if (groupedByCount[c.count - 1] == null) {
                    groupedByCount[c.count - 1] = new ArrayList<String>();
                }
                groupedByCount[c.count].add(c.word);
                groupedByCount[c.count - 1].add(c.word);
            }

            BufferedWriter outputWriter = new BufferedWriter(new OutputStreamWriter(System.out));
            for (int count = groupedByCount.length; count > 0; count--) {
                ArrayList<String> lst = groupedByCount[count - 1];
                if (lst == null) {
                    continue;
                }
                Collections.sort(lst);
                for (String word : lst) {
                    outputWriter.write(word + "\t" + count);
                    outputWriter.newLine();
                }
            }
            outputWriter.close();
        }
    }
}
