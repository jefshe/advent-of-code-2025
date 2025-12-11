defmodule Day8 do
  def run do
    IO.puts("Day 8")

    part_a()
    |> IO.inspect(label: "part_a")

    part_b()
    |> IO.inspect(label: "part_b")
  end

  def part_a do
    parse_part(:ex)
  end

  def part_b do
  end

  @spec parse_part(:a | :b | :ex) :: [{integer(), integer(), integer()}]
  def parse_part(part) do
    Utils.read_file_stream(8, part)
    |> Enum.map(&String.split(&1, ","))
    |> Enum.map(fn chars -> Enum.map(chars, &String.to_integer/1) end)
    |> Enum.map(&List.to_tuple/1)
  end
end
