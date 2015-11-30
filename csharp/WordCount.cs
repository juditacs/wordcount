using System;
using System.Collections.Generic;
using System.Linq;

namespace WordCount
{
    public class Program
    {
        public static void Main()
        {
            var wordCounts = new Dictionary<string, long>();
            string line;
            
            while ((line = Console.ReadLine()) != null) 
            {
                foreach (var word in line.Split(new [] { ' ', '\t' }, StringSplitOptions.RemoveEmptyEntries))
                {
                    wordCounts[word] = wordCounts.ContainsKey(word) ? wordCounts[word] + 1 : 1;
                }
            }
            
            foreach (var wordCount in wordCounts.OrderByDescending(k => k.Value).ThenBy(k => k.Key))
            {
                Console.WriteLine("{0}\t{1}", wordCount.Key, wordCount.Value);
            }
        }
    }
}
