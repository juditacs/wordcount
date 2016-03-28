defmodule Wordcount do
  defmodule Store do
    def new(), do: :ets.new :wc, [:set, :named_table]

    def count(tbl, word) do
      case :ets.lookup(:wc, word) do
        [{^word, cnt}] -> :ets.insert(:wc, {word, cnt + 1})
        []             -> :ets.insert(:wc, {word, 1})
      end
      tbl
    end

    def to_list(tbl) do
      :ets.foldl(fn {w, _} = entry, acc ->
        new_acc = [entry|acc]
        :ets.delete(tbl, w)
        new_acc
      end, [], tbl)
    end
  end

  def main([]), do: wordcount()

  defp wordcount() do
    IO.stream(:stdio, :line)
    |> Stream.flat_map(&Regex.scan(~r/\S+/, &1))
    |> Enum.reduce(Store.new, fn
      word, tbl ->
        Store.count(tbl, word)
    end)
    |> Store.to_list
    |> Enum.sort(fn
      {word1, count},  {word2, count}  -> word1 < word2
      {_,     count1}, {_,     count2} -> count1 > count2
    end)
    |> Enum.map(fn {word, count} -> [word, ?\t, Integer.to_string(count), ?\n] end)
    |> (fn a -> IO.write(:stdio, a) end).()
  end
end

# Improvements:
# 1. Try to implement Hash-Based-Map/use HashDict
# 2. Try an ETS, propably using some Hash-MStuff
