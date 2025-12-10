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
    ingredients |> Enum.filter(fn x -> Enum.any?(ranges, fn r -> x in r end) end) |> Enum.count()
  end

  def part_b do
    {ranges, _} = parse_part(:a)
    find_disjoint_ranges(ranges)
  end

  def find_disjoint_ranges(ranges) do
    ranges
    |> Enum.sort()
    |> Enum.reduce([], fn r, acc ->
      case {r, acc} do
        {r, []} ->
          [r]

        {r_start..r_end//_, [last_start..last_end//_ | rest]} ->
          if(Range.disjoint?(r_start..r_end, last_start..last_end),
            do: [r | acc],
            else: [min(r_start, last_start)..max(r_end, last_end) | rest]
          )
      end
    end)
    |> Enum.map(&Range.size/1)
    |> Enum.sum()
  end

  @spec parse_part(:a | :b | :ex) :: {[Range.t()], [integer()]}
  def parse_part(part) do
    {rangestrings, ["" | ingredients]} =
      Utils.read_file_stream(5, part)
      |> Enum.split_while(&(&1 != ""))

    ranges =
      rangestrings
      |> Enum.map(&string_to_range/1)

    {ranges, ingredients |> Enum.map(&String.to_integer/1)}
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
