defmodule Wordcount do
  defmodule Store do
    def new(), do: :ets.new :wc, [:set, :named_table]

    def count(tbl, ""), do: tbl
    def count(tbl, word) do
      :ets.update_counter(tbl, word, 1, {word, 0})
      tbl
    end

    def to_map(tbl) do
      :ets.foldr(fn {w, c}, acc ->
        new_acc = Map.update(acc, c, [w], &([w|&1]))
        :ets.delete(tbl, w)
        new_acc
      end, %{}, tbl)
    end
  end

  def main(), do: main([]) # needed for profiling only
  def main([]), do: wordcount()

  defp wordcount() do
    pattern = :binary.compile_pattern([" ", "\n", "\t"])
    IO.stream(:stdio, :line)
    |> Stream.flat_map(&:binary.split(&1, pattern, [:global]))
    |> Enum.reduce(Store.new, fn
      word, tbl ->
        Store.count(tbl, word)
    end)
    |> Store.to_map
    |> Enum.sort(fn {c1, _}, {c2, _} -> c1 > c2 end)
    |> Enum.map(fn {c, ws} ->
      cs = Integer.to_string(c)
      Enum.sort(ws)
      |> Enum.map(&([&1, ?\t, cs, ?\n]))
    end)
    |> (fn a -> IO.write(:stdio, a) end).()
  end
end
