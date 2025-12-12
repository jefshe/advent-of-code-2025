defmodule Day9 do
  def run do
    IO.puts("Day 9")

    part_a()
    |> IO.inspect(label: "part_a")

    part_b()
    |> IO.inspect(label: "part_b")
  end

  def part_a do
    {area, _} =
      parse_part(:a)
      |> unique_pairs()
      |> Enum.reduce([], fn {{ax, ay} = a, {bx, by} = b}, acc ->
        [{(abs(ax - bx) + 1) * (abs(ay - by) + 1), {a, b}} | acc]
      end)
      |> Enum.sort()
      |> Enum.max()

    area
  end

  def part_b do
    parse_part(:ex)
  end

  @spec parse_part(:a | :b | :ex) :: any()
  def parse_part(part) do
    Utils.read_file_stream(9, part)
    |> Enum.map(&String.split(&1, ","))
    |> Enum.map(fn chars -> Enum.map(chars, &String.to_integer/1) end)
    |> Enum.map(&List.to_tuple/1)
  end

  def unique_pairs(list) do
    for {x, i} <- Enum.with_index(list),
        {y, j} <- Enum.with_index(list),
        i < j,
        do: {x, y}
  end
end
