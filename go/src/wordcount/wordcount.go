package main

import (
  "os"
  "bufio"
  "sort"
  "fmt"
  "unicode/utf8"
)

func main () {
  scanner := bufio.NewScanner(bufio.NewReader(os.Stdin))
  scanner.Split(ScanWords)
  
  freqs := make(map[string]int)
  for scanner.Scan() {
    freqs[scanner.Text()]++
  }

  keys := make(PairList, len(freqs))
  count := 0
  for k, v := range freqs {
    keys[count] = Pair{Key:k, Value:v}
    count++
  }

  sort.Sort(keys)

  out := bufio.NewWriter(os.Stdout)
  for _, pair := range keys {
    fmt.Fprintf(out, "%s\t%d\n", pair.Key, pair.Value)
  }
  out.Flush()

}

func isSpace(r rune) bool {
  if r <= '\u00FF' {
    // Obvious ASCII ones: \t through \r plus space. Plus two Latin-1 oddballs.
    switch r {
    case ' ', '\t', '\n', '\v', '\f', '\r':
      return true
    case '\u0085':
      return true
    }
    return false
  }
  // High-valued ones.
  if '\u2000' <= r && r <= '\u200a' {
    return true
  }
  switch r {
  case '\u1680', '\u2028', '\u2029', '\u202f', '\u205f', '\u3000':
    return true
  }
  return false
}

func ScanWords(data []byte, atEOF bool) (advance int, token []byte, err error) {
  // Skip leading spaces.
  start := 0
  for width := 0; start < len(data); start += width {
    var r rune
    r, width = utf8.DecodeRune(data[start:])
    if !isSpace(r) {
      break
    }
  }
  // Scan until space, marking end of word.
  for width, i := 0, start; i < len(data); i += width {
    var r rune
    r, width = utf8.DecodeRune(data[i:])
    if isSpace(r) {
      return i + width, data[start:i], nil
    }
  }
  // If we're at EOF, we have a final, non-empty, non-terminated word. Return it.
  if atEOF && len(data) > start {
    return len(data), data[start:], nil
  }
  // Request more data.
  return start, nil, nil
}


type Pair struct {
  Key string
  Value int
}

type PairList []Pair
func (p PairList) Swap(i, j int) { p[i], p[j] = p[j], p[i] }
func (p PairList) Len() int { return len(p) }
func (p PairList) Less(i, j int) bool { return p[i].Value > p[j].Value || (p[i].Value == p[j].Value && p[i].Key < p[j].Key)}