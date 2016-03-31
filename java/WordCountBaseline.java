import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.OutputStreamWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import java.util.Collections;
import java.util.StringTokenizer;

/** Represents a baseline but efficient Java implementation without custom parsing/collections
*   The WordCountOptimized version represents the opposite: a hand-tweaked implementation.
*
*   Main optimizations:
*     - Use a custom object to avoid creating throwaway Integer instances & boxing/unboxing
*     - Buffer input/output
*   
*   * Principal author Rick Hendricksen (xupwup on Github)
*   * Suggestions by sgwerder on GitHub & Sam Van Oort (svanoort on Github)
*/
class WordCountBaseline {
    
    private static class CountForWord implements Comparable<CountForWord> {
        String word;
        int count = 1;

        public CountForWord(String word) {
            this.word = word;
        }

        @Override
        public int compareTo(CountForWord t) {
            if(count < t.count){
                return 1;
            }else if(count > t.count){
                return -1;
            }else{
                return word.compareTo(t.word);
            }
        }
    }


    private static void tokenizeAndSubmit(Map<String, CountForWord> m, String line) {
        String trimmed = line.trim();
        if(!line.isEmpty()) {
            StringTokenizer tok = new StringTokenizer(line, " \t");
            while (tok.hasMoreTokens()) {
                String word = tok.nextToken();
                CountForWord c = m.get(word);
                if (c != null) {
                    c.count++;
                } else {
                    m.put(word, new CountForWord(word));
                }
            }
        }
    }
    
    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        Map<String, CountForWord> m = new HashMap<String, CountForWord>();
        String line;
        while ((line = br.readLine()) != null) {
            tokenizeAndSubmit(m, line);
        }
        br.close();

        System.err.println("sorting...");
        ArrayList<CountForWord> lst = new ArrayList<>(m.values());
        System.err.println("Total tokens: "+lst.size());
        Collections.sort(lst);
        System.err.println("output...");
        BufferedWriter outputWriter = new BufferedWriter(new OutputStreamWriter(System.out));
        for(CountForWord c : lst){
            outputWriter.write(c.word + "\t" + c.count);
            outputWriter.newLine();
        }
        outputWriter.close();
    }
}