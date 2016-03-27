IO.stream(:stdio, :line)
# Split the input in words and reject empty
|> Stream.flat_map(&String.split(&1, ~r/\s/, strip: true))
# Create a dictionary in which the keys are the words and the values are
# the number of appearances in the input text.
|> Enum.reduce(%{}, fn
  "",   counter -> counter # ignore “empty” words
  word, counter ->
    Map.update(counter, word, 1, &(&1 + 1))
end)
# Sort words
|> Enum.sort(fn
  {word1, count1}, {word2, count1} -> word1 < word2 # If appearance count is equal, sort alphabetically
  {_, count1}, {_, count2} -> count1 > count2 # Sort by appearance count
end)
# Prepare results for printing
|> Stream.map(fn {word, count} -> [word, ?\t, Integer.to_string(count), ?\n] end)
# Force the stream into a list
|> Enum.into([])
# and print!
|> IO.puts
