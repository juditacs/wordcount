IO.stream(:stdio, :line)
# Create a dictionary in which the keys are the words and the values are
# the number of appearances in the input text.
|> Enum.reduce(%{}, fn (line, acc) ->
  line
  |> String.split(~r/\s/, strip: true)
  |> Enum.reduce(acc, fn
      "", counter -> counter # Continue if the word is empty
      word, counter -> Map.update(counter, word, 1, &(&1 + 1))
  end)
end)
# Transform the dictionary into a list of tuples with the form {word, appearances}
|> Map.to_list
# Sort words
|> Enum.sort(fn
  {word1, count1}, {word2, count1} -> word1 < word2 # If appearance count is equal, sort alphabetically
  {_, count1}, {_, count2} -> count1 > count2 # Sort by appearance count
end)
# Print the results
|> Enum.each(fn ({word, count}) -> IO.puts("#{word}\t#{count}") end)
