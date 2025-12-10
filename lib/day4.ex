defmodule Day4 do
  def run do
    IO.puts("Day 3")

    part_a()
    |> IO.inspect(label: "part_a")

    part_b()
    |> IO.inspect(label: "part_b")
  end

  def part_a do
    grid = parse_part_a()
    grid[x: 3][y: 0]
  end

  def part_b do
    # parse_part_a()
  end


  def parse_part_a() do
    Utils.read_file_stream(4, :ex)
    |> Enum.map(&String.to_charlist/1)
    |> Nx.tensor(names: [:y, :x])
  end
end
