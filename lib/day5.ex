defmodule Day5 do
  def run do
    IO.puts("Day 5")

    part_a()
    |> IO.inspect(label: "part_a")

    part_b()
    |> IO.inspect(label: "part_b")
  end

  def part_a do
    {ranges, ingredients} = parse_part(:a)

    Enum.count(ingredients, fn x ->
      Enum.any?(ranges, &(x in &1))
    end)
  end

  def part_b do
    {ranges, _} = parse_part(:a)

    deduplicate_ranges(ranges)
    |> Enum.map(&Range.size/1)
    |> Enum.sum()
  end

  def deduplicate_ranges(ranges) do
    ranges
    |> Enum.sort()
    |> Enum.reduce([], &add_or_merge/2)
  end

  defp add_or_merge(range, []), do: [range]

  defp add_or_merge(_..last//_ = range, [head_first..head_last//_ = head | tail]) do
    if Range.disjoint?(range, head) do
      [range, head | tail]
    else
      [head_first..max(last, head_last) | tail]
    end
  end

  @spec parse_part(:a | :b | :ex) :: {[Range.t()], [integer()]}
  def parse_part(part) do
    {rangestrings, ["" | ingredients]} =
      Utils.read_file_stream(5, part)
      |> Enum.split_while(&(&1 != ""))

    ranges = Enum.map(rangestrings, &string_to_range/1)
    ingredients = Enum.map(ingredients, &String.to_integer/1)

    {ranges, ingredients}
  end

  @spec string_to_range(String.t()) :: Range.t()
  def string_to_range(s) do
    [a, b] =
      s
      |> String.split("-")
      |> Enum.map(&String.to_integer/1)

    a..b
  end
end
