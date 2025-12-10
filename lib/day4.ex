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
    {x_size, y_size} = Nx.shape(grid.shape)
    for y <- 0..(y_size-1), x<-0..(x_size-1) do
      IO.puts(Nx.to_number(grid[x: x][y: y]))
    end
  end

  def part_b do
    # parse_part_a()
  end


  def parse_part_a() do
    Utils.read_file_stream(4, :ex)
    |> Enum.map(&String.to_charlist/1)
    |> Enum.map(&Enum.map(&1, fn c -> if c == ?. do 0 else 1 end end))
    |> Nx.tensor(names: [:y, :x])
  end
end
