defmodule Day8 do
  def run do
    IO.puts("Day 8")

    part_a()
    |> IO.inspect(label: "part_a")

    part_b()
    |> IO.inspect(label: "part_b")
  end

  def part_a do
    connect_n = 1000
    graph =
      parse_part(:a)
      |> unique_pairs()
      |> Enum.reduce([], fn {x, y}, acc ->
        [{{Nx.to_list(x), Nx.to_list(y)}, Nx.subtract(x, y) |> Nx.pow(2) |> Nx.sum() |> Nx.to_number()} | acc]
      end)
      |> Enum.sort(fn {_, a}, {_, b} -> a <= b end)
      |> Enum.take(connect_n)
      |> IO.inspect()
      |> Enum.map(fn {nodes, _} -> nodes end)
      |> Enum.reduce(Graph.new(), fn {a, b}, graph ->
        Graph.add_edge(graph, a, b)
      end)

    Graph.components(graph) |> Enum.map(&Enum.count/1) |> Enum.sort(:desc) |> Enum.take(3) |> IO.inspect() |> Enum.product()
  end

  def part_b do
  end

  def unique_pairs(list) do
    for {x, i} <- Enum.with_index(list),
        {y, j} <- Enum.with_index(list),
        i < j,
        do: {x, y}
  end

  @spec parse_part(:a | :b | :ex) :: [{integer(), integer(), integer()}]
  def parse_part(part) do
    Utils.read_file_stream(8, part)
    |> Enum.map(&String.split(&1, ","))
    |> Enum.map(fn chars -> Enum.map(chars, &String.to_integer/1) end)
    |> Enum.map(&Nx.tensor/1)

    # |> Enum.map(&List.to_tuple/1)
  end
end
