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
      |> Enum.reduce([], fn {{ax, ay, az} = a, {bx, by, bz} = b}, acc ->
        [{{a, b}, (ax - bx) ** 2 + (ay - by) ** 2 + (az - bz) ** 2} | acc]
      end)
      |> Enum.sort(fn {_, a}, {_, b} -> a <= b end)
      |> Enum.take(connect_n)
      |> Enum.map(fn {nodes, _} -> nodes end)
      |> Enum.reduce(Graph.new(), fn {a, b}, graph ->
        Graph.add_edge(graph, a, b)
      end)

    Graph.components(graph)
    |> Enum.map(&Enum.count/1)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.product()
  end

  def part_b do
    list = parse_part(:a)

    connections =
      list
      |> unique_pairs()
      |> Enum.reduce([], fn {{ax, ay, az} = a, {bx, by, bz} = b}, acc ->
        [{{a, b}, (ax - bx) ** 2 + (ay - by) ** 2 + (az - bz) ** 2} | acc]
      end)
      |> Enum.sort(fn {_, a}, {_, b} -> a <= b end)
      |> Enum.map(fn {nodes, _} -> nodes end)

    connect_up(Graph.new(type: :undirected), connections, Enum.count(list))
  end

  @spec connect_up(Graph.t(), nonempty_maybe_improper_list(), number()) ::
          {non_neg_integer(), any()}
  def connect_up(g, [{a, b} | rest], size) do
    new_g = Graph.add_edge(g, a, b)
    [span_set | _] = Graph.components(new_g)

    case Enum.count(span_set) do
      cnt when cnt == size -> elem(a, 0) * elem(b, 0)
      _ -> connect_up(new_g, rest, size)
    end
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
    |> Enum.map(&List.to_tuple/1)
  end
end
