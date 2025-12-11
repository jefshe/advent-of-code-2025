defmodule Day8 do
  def run do
    IO.puts("Day 8")

    part_a()
    |> IO.inspect(label: "part_a")

    part_b()
    |> IO.inspect(label: "part_b")
  end

  def part_a do
    pq = PriorityQueue.new()
    connect_n = 10

    pq =
      parse_part(:a)
      |> unique_pairs()
      |> Enum.reduce(pq, fn {x, y}, acc ->
        PriorityQueue.push(
          acc,
          {Nx.to_list(x), Nx.to_list(y)},
          Nx.subtract(x, y) |> Nx.pow(2) |> Nx.sum() |> Nx.to_number()
        )
      end)

    {graph, _} =
      Enum.reduce(1..connect_n, {Graph.new(), pq}, fn _, {graph, pq} ->
        add_connected_nodes(graph, pq)
      end)

    graph
  end

  def add_connected_nodes(graph, pq) do
    {{:value, {a, b}}, new_pq} = PriorityQueue.pop(pq)
    {Graph.add_edge(graph, a, b), new_pq}
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
