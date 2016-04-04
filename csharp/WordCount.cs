using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Text;

namespace WordCountProgram
{
    internal static class Program
    {
        private static void Main()
        {
            Encoding inputEncoding = new UTF8Encoding(encoderShouldEmitUTF8Identifier: false, throwOnInvalidBytes: false);

            using (Stream inputStream = Console.OpenStandardInput())
            using (Stream outputStream = Console.OpenStandardOutput())
            using (StreamReader inputReader = new StreamReader(inputStream, inputEncoding, false, 4096, true))
            using (StreamWriter outputWriter = new StreamWriter(outputStream, Console.OutputEncoding, 4096, true))
            {
                Console.SetIn(inputReader);
                Console.SetOut(outputWriter);

                var wordCountIndexes = new Dictionary<string, int>();
                var wordCountList = new List<WordCount>();
                string line;
                int wcIndex;

                char[] splitChars = { ' ', '\t' };
                while ((line = Console.ReadLine()) != null)
                {
                    foreach (var word in line.Split(splitChars, StringSplitOptions.RemoveEmptyEntries))
                    {
                        WordCount wc;
                        if (wordCountIndexes.TryGetValue(word, out wcIndex))
                        {
                            wc = wordCountList[wcIndex];
                        }
                        else
                        {
                            wordCountIndexes[word] = wordCountList.Count;
                            wordCountList.Add(wc = new WordCount(word));
                        }

                        wc.Count++;
                    }
                }

                wordCountList.Sort();

                // cache the output strings for words with counts under 1024.
                string[] cachedStrings = new string[1024];
                for (int i = 0; i < cachedStrings.Length; i++)
                {
                    cachedStrings[i] = i.ToString(CultureInfo.InvariantCulture);
                }

                foreach (var wordCount in wordCountList)
                {
                    Console.WriteLine(wordCount.Word +
                                      '\t' +
                                      (wordCount.Count < cachedStrings.Length
                                           ? cachedStrings[wordCount.Count]
                                           : wordCount.Count.ToString(CultureInfo.InvariantCulture)));
                }
            }
        }
    }

    internal sealed class WordCount : IComparable<WordCount>
    {
        public readonly string Word;

        public long Count;

        internal WordCount(string word)
        {
            Word = word;
        }

        public int CompareTo(WordCount other)
        {
            var compareTo = this.Count.CompareTo(other.Count);
            return compareTo == 0
                ? String.Compare(this.Word, other.Word, StringComparison.Ordinal)
                : -compareTo;
        }
    }
}