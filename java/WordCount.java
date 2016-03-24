import java.io.BufferedWriter;
import java.io.OutputStreamWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import java.util.Collections;
import java.nio.channels.ReadableByteChannel;
import java.nio.channels.Channels;
import java.nio.ByteBuffer;

/** Word count for Java. Slow because of boxing/unboxing. */
class WordCount {
    
    private static class CountForWord implements Comparable<CountForWord>{
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
    
    
    private static Map<String, CountForWord> generateWordMap() throws IOException{
        Map<String, CountForWord> m = new HashMap<>();
        try (ReadableByteChannel channel = Channels.newChannel(System.in)) {
            ByteBuffer buffer = ByteBuffer.allocateDirect(8192);

            buffer.clear();
            
            int startPos = 0;
            while(channel.read(buffer) != -1){
                buffer.flip();
                
                for(int i = startPos; i < buffer.limit(); i++){
                    byte b = buffer.get(i); // get char without advancing
                    if(b == (byte) '\t' || b == (byte) ' ' || b == (byte) '\n'){
                        if(buffer.position() != i){
                            byte[] wordBytes = new byte[i - buffer.position()];
                            buffer.get(wordBytes);
                            String word = new String(wordBytes, "UTF-8");
                            submitWord(m, word);
                        }
                        buffer.get(); // advance buffer one byte
                    }
                }
                buffer.compact();
                startPos = buffer.position();
            }
            // what remains in the buffer must be a word, or nothing
            if(buffer.position() > 0){
                byte[] wordBytes = new byte[buffer.position()];
                buffer.get(wordBytes);
                String word = new String(wordBytes, "UTF-8").trim();
                if(!word.isEmpty()){
                    submitWord(m, word);
                }
            }
        }
        return m;
    }
    
    
    public static void main(String[] args) throws IOException {
        Map<String, CountForWord> m = generateWordMap();
        
        System.err.println("sorting...");
        ArrayList<CountForWord> lst = new ArrayList<>(m.values());
        Collections.sort(lst);
        System.err.println("output...");
        try (BufferedWriter outputWriter = new BufferedWriter(new OutputStreamWriter(System.out))) {
            for(CountForWord c : lst){
                outputWriter.write(c.word + "\t" + c.count);
                outputWriter.newLine();
            }
        }
    }
}
