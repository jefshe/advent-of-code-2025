defmodule Day3 do
  def run do
    IO.puts("Day 3")

    part_a()
    |> IO.inspect(label: "part_a")

    part_b()
    |> IO.inspect(label: "part_b")
  end

  def part_a do
    parse_part_a()
      |> Enum.map(&String.graphemes/1)
      |> Enum.map(fn [a | rest] -> find_largest_pair(rest, a) end)
      |> Enum.sum()
  end

  def part_b do
    parse_part_a()
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(fn line -> find_largest_n(line, 12) end)
    |> Enum.map(&numify_list/1)
    |> Enum.sum()
  end

  @spec find_largest_pair(List[String.t()], String.t()) :: integer()
  def find_largest_pair(line, curr_max) do
    case line do
      [head] -> numify(curr_max, head)
      [head | rest] -> max(find_largest_pair(rest, max(curr_max, head)), numify(curr_max, head))
    end
  end

  def numify(a, b) do
    String.to_integer(a) * 10  + String.to_integer(b)
  end

  def numify_list(l) when is_list(l) do
    Enum.map(l, &String.to_integer/1)
    |> Enum.reduce(fn x, acc -> acc * 10 + x end)
  end

  @spec find_largest_n(List[String.t()], integer()) :: List[String.t()]
  def find_largest_n(line, n) do
    cond do
      n == 1 -> [Enum.max(line)]
      length(line) === n -> line
      true ->
        [head | rest] = line
        curr_max = find_largest_n(rest, n)
        if(hd(curr_max) > head, do: curr_max, else: [head | find_largest_n(curr_max, n-1)])
    end
  end

  def parse_part_a() do
    Utils.read_file_stream(3, :a)
    |> Enum.to_list()
  end
end
