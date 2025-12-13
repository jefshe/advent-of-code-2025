defmodule Day11 do
  def run do
    IO.puts("Day 11")

    part_a()
    |> IO.inspect(label: "part_a")

    part_b()
    |> IO.inspect(label: "part_b")
  end

  def part_a do
    parse_part(:a)
    |> Enum.map(fn {node, vs} -> Enum.map(vs, &Graph.Edge.new(node, &1)) end)
    |> Enum.reduce(Graph.new(), &Graph.add_edges(&2, &1))
    |> Graph.get_paths("you", "out")
    |> Enum.count()
  end

  def part_b do
    g =
      parse_part(:a)
      |> Enum.map(fn {node, vs} -> Enum.map(vs, &Graph.Edge.new(node, &1)) end)
      |> Enum.reduce(Graph.new(), &Graph.add_edges(&2, &1))

    can_reach_fft = Graph.reachable(g, ["fft"])
    can_reach_dac = Graph.reachable(g, ["dac"])
    can_reach_out = Graph.reachable(g, ["out"])

    valid_nodes = (can_reach_dac ++ can_reach_fft ++ can_reach_out) |> Enum.uniq() |> MapSet.new()
    IO.inspect(valid_nodes)

    delete_nodes =
      Graph.vertices(g)
      |> Enum.reject(fn v -> v in valid_nodes end)

    IO.inspect(delete_nodes)

    pruned_g = Graph.delete_vertices(g, delete_nodes)
    IO.inspect(g)
    IO.inspect(pruned_g)

    Graph.get_paths(pruned_g, "srv", "out")
    |> Enum.count()
  end

  def prune_paths(graph) do
  end

  def prune_paths(graph, []) do
    graph
  end

  def prune_paths(graph, [head | tail]) do
    prune_paths(graph, tail)
  end

  def search_paths(_, []), do: true
  def search_paths([], _), do: false
  @spec search_paths(list(), list()) :: boolean()
  def search_paths([head | tail], search_for) do
    search_paths(tail, Enum.reject(search_for, &(&1 == head)))
  end

  @spec parse_part(:a | :b | :ex | :ex2) :: [{String.t(), [String.t()]}]
  def parse_part(part) do
    Utils.read_file_stream(11, part)
    |> Enum.map(&String.split(&1, ": "))
    |> Enum.map(fn [node, vs] -> {node, String.split(vs, " ")} end)
  end
end
