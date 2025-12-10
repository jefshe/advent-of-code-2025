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

  @spec find_largest_pair(List[String.t()], String.t()) :: integer()
  def find_largest_pair(line, curr_max) when length(line) == 1 do
    numify(curr_max,hd(line))
  end

  @spec find_largest_pair(List[String.t()], String.t()) :: integer()
  def find_largest_pair(line, curr_max) do
    [head | rest] = line
    max(find_largest_pair(rest, max(curr_max, head)), numify(curr_max, head))
  end

  def numify(a, b) do
    String.to_integer(a) * 10  + String.to_integer(b)
  end

  def part_b do
    # parse_part_a()
  end

  def parse_part_a() do
    Utils.read_file_stream(3, :a)
    |> Enum.to_list()
  end
end
