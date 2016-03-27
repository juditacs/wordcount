defmodule Wordcount do
  def main([]), do: wordcount()

  defp wordcount() do
    IO.stream(:stdio, :line)
    |> Stream.flat_map(&Regex.scan(~r/\S+/, &1))
    |> Enum.reduce(%{}, fn
      "",   cnt -> cnt
      word, cnt -> Map.update(cnt, word, 1, &(&1 + 1))
    end)
    |> Enum.sort(fn
      {word1, count},  {word2, count}  -> word1 < word2
      {_,     count1}, {_,     count2} -> count1 > count2
    end)
    |> Enum.map(fn {word, count} -> [word, ?\t, Integer.to_string(count), ?\n] end)
    |> (fn a -> IO.write(:stdio, a) end).()
  end
end
