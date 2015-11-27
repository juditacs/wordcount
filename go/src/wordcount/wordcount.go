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