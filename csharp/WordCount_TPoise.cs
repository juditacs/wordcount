using System;
using System.Collections.Generic;
using System.Linq;

namespace WordCount_TPoise
{
    public class Program
    {
        public static void Main()
        {
            var wordCounts = new Dictionary<string, uint>(Convert.ToInt32(Math.Pow(2.0, 16.0)));
            string line;

            while ((line = Console.ReadLine()) != null)
            {
                uint count = 0;

                foreach (string word in line.Split(new[] { ' ', '\t' }, StringSplitOptions.RemoveEmptyEntries))
                {
                    if (wordCounts.TryGetValue(word, out count))
                        wordCounts[word] = ++count;
                    else
                        wordCounts[word] = 1;

                }
            }

            foreach (var wordCount in wordCounts.AsParallel().OrderByDescending(k => k.Value).ThenBy(k => k.Key).Take(10))
            {
                Console.WriteLine("{0}\t{1}", wordCount.Key, wordCount.Value);
            }

        }
        
    }
}