import java.io.BufferedOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.nio.charset.StandardCharsets;
import java.nio.ByteBuffer;

import gnu.trove.map.custom_hash.TObjectIntCustomHashMap;
import gnu.trove.map.hash.TObjectIntHashMap;
import gnu.trove.strategy.HashingStrategy;
import gnu.trove.procedure.TObjectIntProcedure;

/** Word count for Java.
 *  Fast and memory-efficient because we use a primitives collection 
 *  and store Strings as UTF-8 bytes.
 */
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

    // Constants for parsing
    static final byte BYTE_SPACE = (byte)' ';
    static final byte BYTE_TAB = (byte)'\t';
    static final byte BYTE_NEWLINE = (byte)'\n';

    /** Reads a chunk of characters, tokenizes it, and submits tokens
    *  After execution, it shuffles residual characters to the start of the array
    *  And returns the number of characters remaining to include in the next token
    */
    public static int tokenizeAndSubmitBlock(TObjectIntCustomHashMap<byte[]> counts,
        final byte[] inputBuffer, int startIndex, int charsRead) {

        int index = 0; // Start of current token
        int endIndex = startIndex + charsRead;

        // Go from start to end of current read
        for (int i=startIndex; i<endIndex; i++) {
            byte b = inputBuffer[i];

            if (b == BYTE_SPACE || b == BYTE_NEWLINE || b == BYTE_TAB) { // New token
                if (i != index) {
                    byte[] word = new byte[i-index];
                    System.arraycopy(inputBuffer, index, word, 0, word.length);                    
                    submitWord(counts, word);
                    index = i;
                }
                index++;
            }
        }

        // Copy residual token content to beginning of the array, start going again
        int residualSize =  endIndex - index;
        if (residualSize > 0) {
            System.arraycopy(inputBuffer, index, inputBuffer, 0, residualSize);
            return residualSize;
        }
        return 0;
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
	
    static void fastRadixSort(ArrayList<byte[]> byteArrayList, int byteOffset) {
        if (byteArrayList.size() > 4096) { // Overheads not justified for small arrays
            ArrayList<byte[]>[] buckets = new ArrayList[256];
            final int slotSize = Math.max(byteArrayList.size()>>8, 4);
            ArrayList<byte[]> prefix = new ArrayList<byte[]>(); //Values not long enough to have this byte
            int len = byteArrayList.size();
            for(int i=0; i<len; i++) {
                byte[] val = byteArrayList.get(i);
                if (byteOffset >= val.length) {
                    prefix.add(val);
                } else {
                    int index = val[byteOffset] & 0xFF;
                    ArrayList<byte[]> slot = buckets[index];
                    if (slot == null) {
                        slot = new ArrayList<byte[]>(slotSize);
                        buckets[index] = slot;
                    }
                    slot.add(val);  
                }
            }
            // Prefix is already sorted
            byteArrayList.clear();
            byteArrayList.addAll(prefix);
            for (int i=0; i<buckets.length; i++) {
                ArrayList<byte[]> slot = buckets[i];
                if (slot != null) {
                    fastRadixSort(slot, byteOffset+1);
                    byteArrayList.addAll(slot);    
                }
            }
        } else {
            Collections.sort(byteArrayList, BYTE_COMPARATOR_INSTANCE);
         }
    }

    private static final ByteArrayComparator BYTE_COMPARATOR_INSTANCE = new ByteArrayComparator();
    
    private static void submitWord(TObjectIntCustomHashMap<byte[]> m, byte[] word) {
        m.adjustOrPutValue(word, 1, 1);        
    }
    
    public static void main(String[] args) throws IOException {
        System.err.println("Parsing and adding to map");
        long startTime = System.currentTimeMillis();
        InputStream stdin = System.in;
        TObjectIntCustomHashMap<byte[]> m = new TObjectIntCustomHashMap<byte[]>(new BytesHashingStrategy(),1000000, 0.75f, -1);
        
        byte[] buff = new byte[8192];  // Limits maximum token size

        // Read through chunks, tokenizing them directly on byte array
        int readAmount;
        int offset = 0;
        while ((readAmount = stdin.read(buff, offset, buff.length-offset)) > 0 ) {
            offset = tokenizeAndSubmitBlock(m, buff, offset, readAmount);
        }
        if (offset > 0) {
            byte[] finalToken = new byte[offset];
            System.arraycopy(buff, 0, finalToken, 0, offset);
            submitWord(m, finalToken);
        }
        long endTime = System.currentTimeMillis();
        System.err.println("Parsing/map addition time (ms): "+(endTime-startTime));

        System.err.println("Creating Count objects for sorting");
        startTime = System.currentTimeMillis();

        final ArrayList<CountForWord> multiples = new ArrayList<CountForWord>(m.size()/2);
        final ArrayList<byte[]> singles = new ArrayList<byte[]>(m.size()/2);

        TObjectIntProcedure<byte[]> proc = new TObjectIntProcedure<byte[]>(){
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
        endTime = System.currentTimeMillis();
        System.err.println("Sorting multiples time (ms): "+(endTime-startTime)+ " with count: "+multiples.size());

        startTime = System.currentTimeMillis();
        fastRadixSort(singles, 0);
        endTime = System.currentTimeMillis();
        System.err.println("Sorting single time (ms): "+(endTime-startTime) + " with count: "+singles.size());

        System.err.println("output...");
        startTime = System.currentTimeMillis();

        BufferedOutputStream out = new BufferedOutputStream(System.out);
        for (CountForWord c : multiples) {
            out.write(c.word);
            out.write(("\t"+c.count+'\n').getBytes(StandardCharsets.UTF_8));
        }
        byte[] simpleSuffix = "\t1\n".getBytes(StandardCharsets.UTF_8);
        for (byte[] b : singles) {
            out.write(b);
            out.write(simpleSuffix);
        }
        out.close();
        endTime = System.currentTimeMillis();
        System.err.println("Output time (ms): "+(endTime-startTime));
    }
}