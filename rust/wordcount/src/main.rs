use std::io::{self, Read, Write, BufWriter};
use std::collections::HashMap;

fn main() {
    let mut buffer = String::new();
    io::stdin().read_to_string(&mut buffer).ok();

    let mut words: HashMap<&str, usize> = HashMap::new();
    for word in buffer.split(is_whitespace).filter(is_not_empty) {
        if let Some(count) = words.get_mut(word) {
            *count += 1;
            continue;
        }
        words.insert(word, 1);
    }

    let mut sortable_words: Vec<(&str, usize)> = words.iter()
                                                      .map(|(word, count)| (*word, *count))
                                                      .collect();
    sortable_words.sort_by_key(|a| a.0);
    sortable_words.sort_by(|a, b| b.1.cmp(&a.1));

    let mut output = BufWriter::new(io::stdout());
    for word in sortable_words {
        writeln!(output, "{}\t{}", word.0, word.1).ok();
    }
}

#[inline]
fn is_not_empty(s: &&str) -> bool {
    !s.is_empty()
}

#[inline]
fn is_whitespace(c: char) -> bool {
    c == ' ' || c == '\t' || c == '\n'
}
