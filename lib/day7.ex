defmodule Day7 do
  def run() do
    IO.puts("Day 7")

    part_a()
    |> IO.inspect(label: "part_a")

    # part_b()
    # |> IO.inspect(label: "part_b")
  end

  @beam 2
  @splitter 1
  @empty 0

  def part_a() do
    parse_part(:ex)
    |> simulate(0,0)
  end

  def part_b() do
  end

  def simulate(grid, x, y) do
    {y_dim, x_dim} = grid.shape
    grid = case {Nx.to_number(grid[y][x]), Nx.to_number(grid[y+1][x])} do
      _ when y+1 >= y_dim -> grid
      {@beam, @splitter} ->
          if(x+1 < x_dim, do: Nx.indexed_put(grid, Nx.tensor([y+1, x+1]), @beam), else: grid)
          |> then(fn g-> if(x-1 >= 0, do: Nx.indexed_put(g, Nx.tensor([y+1, x-1]), @beam), else: g) end)
      {@beam, _} -> Nx.indexed_put(grid, Nx.tensor([y+1, x]), @beam)
      _ -> grid
    end


    case {x,y} do
      {x,y} when x+1 < x_dim -> simulate(grid, x+1, y)
      {_,y} when y+1 < y_dim -> simulate(grid, 0, y+1)
      _ -> grid
    end
  end

  @spec parse_part(:a | :b | :ex) :: {[Range.t()], [integer()]}
  def parse_part(part) do
    Utils.read_file_stream(7, part)
    |> Enum.map(&String.to_charlist/1)
    |> Enum.map(
      &Enum.map(&1, fn c ->
        case(c) do
          ?. -> @empty
          ?S -> @beam
          ?^ -> @splitter
        end
      end)
    )

    |> Nx.tensor(names: [:y, :x])
  end

end
