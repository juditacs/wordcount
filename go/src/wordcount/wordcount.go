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

  for _, word := range keys {
    fmt.Printf("%s\t%d\n", word, freqs[word])
  }

}