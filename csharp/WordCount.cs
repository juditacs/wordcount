using System;
using System.Collections.Generic;
using System.Linq;

namespace WordCountProgram
{
    public class Program
    {
        public static void Main()
        {
            var wordCounts = new Dictionary<string, WordCount>();
            var wordCountList = new List<WordCount>();
            string line;
            WordCount wc = null;
            while ((line = Console.ReadLine()) != null)
            {
                foreach (var word in line.Split(new[] { ' ', '\t' }, StringSplitOptions.RemoveEmptyEntries))
                {
                    if (wordCounts.TryGetValue(word, out wc))
                    {
                        wc.Count++;
                    }
                    else
                    {
                        var initialwordCount = new WordCount(word);
                        wordCounts[word] = initialwordCount;
                        wordCountList.Add(initialwordCount);
                    }
                }
            }

            wordCountList.Sort(new WordCountComparer());

            foreach (var wordCount in wordCountList)
            {
                Console.WriteLine("{0}\t{1}", wordCount.Word, wordCount.Count);
            }
        }
    }

    public class WordCount
    {
        public WordCount(string word)
        {
            Word = word;
            Count = 1;
        }

        public readonly string Word;

        public long Count;
    }

    public class WordCountComparer : IComparer<WordCount>
    {
        public int Compare(WordCount x, WordCount y)
        {
            var compareTo = Comparer<long>.Default.Compare(x.Count, y.Count);

            if (compareTo != 0)
                return -compareTo;

            return String.Compare(x.Word, y.Word, StringComparison.Ordinal);
        }
    }
}
