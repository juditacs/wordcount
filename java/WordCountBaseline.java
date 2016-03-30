import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.OutputStreamWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import java.util.Collections;

/** Represents a baseline but very efficient Java implementation without custom parsing
*   Main optimizations:
*     - Use a custom object to avoid creating throwaway Integer instance & boxing/unboxing
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
    
    private static void submitWord(Map<String, CountForWord> m, String word){
        CountForWord c;
        if((c = m.get(word)) != null){
            c.count ++;
        }else{
            m.put(word, new CountForWord(word));
        }
    }
    
    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        Map<String, CountForWord> m = new HashMap<String, CountForWord>();
        String line;
        while ((line = br.readLine()) != null) {
            line = line.trim();
            if (!line.isEmpty()) {
                int index = 0;
                for(int i = 0; i < line.length(); i++){
                    char c = line.charAt(i);
                    if(c == '\t' || c == ' '){
                        if(index == i){
                            index ++;
                        }else{
                            String word = line.substring(index, i);
                            index = i + 1;
                            submitWord(m, word);
                        }
                    }
                }
                if(index < line.length()){
                    submitWord(m, line.substring(index));
                }
            }
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