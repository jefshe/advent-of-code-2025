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
    {x_max, y_max} = {x_size - 1, y_size - 1}

    found =
      for y <- 0..y_max, x <- 0..x_max do
        if Nx.to_number(grid[x: x][y: y]) == 1 do
          if(
            grid[x: max(x - 1, 0)..min(x + 1, x_max)][
              y: max(y - 1, 0)..min(y + 1, y_max)
            ]
            |> Nx.sum()
            |> Nx.to_number() <= 4,
            do: 1,
            else: 0
          )
        else
          0
        end
      end

    Enum.sum(found)

    # Nx.to_heatmap(grid)
  end

  def part_b do
    # parse_part_a()
  end

  def parse_part_a() do
    Utils.read_file_stream(4, :a)
    |> Enum.map(&String.to_charlist/1)
    |> Enum.map(
      &Enum.map(&1, fn c ->
        if c == ?. do
          0
        else
          1
        end
      end)
    )
    |> Nx.tensor(names: [:y, :x])
  end
end
