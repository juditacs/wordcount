IO.stream(:stdio, :line)
# Create a dictionary in which the keys are the words and the values are
# the number of appearances in the input text.
|> Enum.reduce(%{}, fn (line, acc) ->
  line
  |> String.split(~r/\s/, strip: true)
  |> Enum.reduce(acc, fn (word, counter) ->
    if String.length(word) == 0 do
      counter
    else
      case Map.get(counter, word) do
        nil -> Map.put(counter, word, 1)
        prev_count -> Map.put(counter, word, prev_count + 1)
      end
    end
  end)
end)
# Transform the dictionary into a list of tuples with the form {word, appearances}
|> Map.to_list
# Sort words (if appearance count are equal, sort alphabetically)
|> Enum.sort(fn ({word1, count1}, {word2, count2}) ->
  cond do
    count2 == count1 -> word1 < word2
    true -> count1 > count2
  end
end)
# Print the results
|> Enum.each(fn ({word, count}) -> IO.puts("#{word}\t#{count}") end)
