import java.io.BufferedWriter;
import java.io.OutputStreamWriter;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.channels.Channels;
import java.nio.channels.ReadableByteChannel;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import java.util.Collections;

/** Word count for Java. Slow because of boxing/unboxing. */
class WordCountArray {
    
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
    
    private static int submitWord(Map<String, CountForWord> m, String word){
        CountForWord c;
        if((c = m.get(word)) != null){
            c.count ++;
        }else{
            m.put(word, c = new CountForWord(word));
        }
        return c.count;
    }
    
    public static void main(String[] args) throws IOException {
        int maxCount = 0;
        
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
                            int count = submitWord(m, word);
                            maxCount = Math.max(count, maxCount);
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
                    int count = submitWord(m, word);
                    maxCount = Math.max(count, maxCount);
                }
            }
        }

        System.err.println("sorting...");
        
        ArrayList<String>[] groupedByCount = new ArrayList[maxCount];
        for(CountForWord c : m.values()){
            if(groupedByCount[c.count-1] == null){
                groupedByCount[c.count-1] = new ArrayList<String>();
            }
            groupedByCount[c.count-1].add(c.word);
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
