package main

import (
  "os"
  "bufio"
  "sort"
  "fmt"
)

func main () {
  scanner := bufio.NewScanner(bufio.NewReader(os.Stdin))
  scanner.Split(bufio.ScanWords)
  
  freqs := make(map[string]int)
  for scanner.Scan() {
    freqs[scanner.Text()]++
  }

  keys := make([]string, len(freqs))
  count := 0
  for k := range freqs {
    keys[count] = k
    count++
  }

  sort.Strings(keys)

  out := bufio.NewWriter(os.Stdout)
  for _, word := range keys {
    fmt.Fprintf(out, "%s\t%d\n", word, freqs[word])
  }
  out.Flush()

}