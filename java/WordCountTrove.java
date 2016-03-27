import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.OutputStreamWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.nio.charset.StandardCharsets;

import gnu.trove.map.custom_hash.TObjectIntCustomHashMap;
import gnu.trove.map.hash.TObjectIntHashMap;
import gnu.trove.strategy.HashingStrategy;
import gnu.trove.procedure.TObjectIntProcedure;

/** Word count for Java. Slow because of boxing/unboxing. */
class WordCountTrove {

    private static class BytesHashingStrategy implements HashingStrategy<byte[]> {
        @Override
        public int computeHashCode(byte[] object) {
            return Arrays.hashCode(object);
        }

        // Compare byte-byte byte, if they're equal aside from length, return last
        @Override
        public boolean equals(byte[] b1, byte[] b2) {
            return b1 == b2 || Arrays.equals(b1, b2);
        }
    } 

    private static class CountForWord implements Comparable<CountForWord>{
        byte[] word;
        int count = 1;


        public CountForWord(byte[] word, int count) {
            this.word = word;
            this.count = count;
        }

        @Override
        public int compareTo(CountForWord t) {
            if(count < t.count){
                return 1;
            } else if(count > t.count) {
                return -1;
            } else {
                return BYTE_COMPARATOR_INSTANCE.compare(this.word, t.word);
            }
        }

        public StringBuilder toStringBuilder() {
            StringBuilder retval = new StringBuilder(word.length+6);
            retval.append(new String(word, StandardCharsets.UTF_8))
                .append('\t')
                .append(count);
            return retval;
        }
    }

    private static class ByteArrayComparator implements Comparator<byte[]> {
        @Override
        public int compare(byte[] b1, byte[] b2) {
            // Sorting by byte value is less correct
            // but avoids very expensive UTF-8 decoding
            int limit = Math.min(b1.length, b2.length);
            for(int i=0; i<limit; i++) {
                int diff = b1[i] - b2[i];
                if (diff != 0) {
                    return diff;
                }
            }
            return b1.length-b2.length;
        }

        @Override
        public boolean equals(Object o) {
            return o == this;
        }
    }

    private static final ByteArrayComparator BYTE_COMPARATOR_INSTANCE = new ByteArrayComparator();
    
    private static void submitWord(TObjectIntCustomHashMap<byte[]> m, byte[] word) {
        m.adjustOrPutValue(word, 1, 1);        
    }
    
    public static void main(String[] args) throws IOException {
        System.err.println("Parsing and adding to map");
        long startTime = System.currentTimeMillis();
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in, "UTF-8"));
        TObjectIntCustomHashMap<byte[]> m = new TObjectIntCustomHashMap<byte[]>(new BytesHashingStrategy(),1000000, 0.75f, -1);
        String line;
        while ((line = br.readLine()) != null) {
            line = line.trim();
            if (!line.isEmpty()) {
                int index = 0;
                for(int i = 0; i < line.length(); i++){
                    char c = line.charAt(i);
                    if(c == '\t' || c == ' '){
                        if (index == i) {
                            index ++;
                        } else {
                            byte[] word = line.substring(index, i).getBytes(StandardCharsets.UTF_8);
                            index = i + 1;
                            submitWord(m, word);
                        }
                    }
                }
                if(index < line.length()){
                    submitWord(m, line.substring(index).getBytes(StandardCharsets.UTF_8));
                }
            }
        }
        br.close();
        long endTime = System.currentTimeMillis();
        System.err.println("Parsing/map addition time (ms): "+(endTime-startTime));

        System.err.println("Creating Count objects for sorting");
        startTime = System.currentTimeMillis();

        ArrayList<CountForWord> multiples = new ArrayList<CountForWord>(m.size()/2);
        ArrayList<byte[]> singles = new ArrayList<byte[]>(m.size()/2);

        TObjectIntProcedure<byte[]> proc = new TObjectIntProcedure<byte[]>(){
            int i=0; 

            @Override
            public boolean execute(byte[] a, int b) {
                if (b > 1) {
                    multiples.add(new CountForWord(a, b));
                } else {
                    singles.add(a);
                }
                return true;
            }
        };
        m.forEachEntry(proc);
        m = null; // Just-in-case, this allows for GC
        endTime = System.currentTimeMillis();
        System.err.println("Count object creation time (ms): "+(endTime-startTime));

        System.err.println("sorting...");
        startTime = System.currentTimeMillis();
        Collections.sort(multiples);
        Collections.sort(singles, BYTE_COMPARATOR_INSTANCE);
        endTime = System.currentTimeMillis();
        System.err.println("Sorting time (ms): "+(endTime-startTime));

        System.err.println("output...");
        startTime = System.currentTimeMillis();
        BufferedWriter outputWriter = new BufferedWriter(new OutputStreamWriter(System.out));
        for (CountForWord c : multiples) {
            outputWriter.write((c.toStringBuilder().append('\n')).toString());
        }
        for (byte[] b : singles) {
            outputWriter.write(new String(b, StandardCharsets.UTF_8) + "\t1\n");
        }
        outputWriter.close();
        endTime = System.currentTimeMillis();
        System.err.println("Output time (ms): "+(endTime-startTime));
    }
}