defmodule Day7 do
  def run() do
    IO.puts("Day 7")

    # part_a()
    # |> IO.inspect(label: "part_a")

    part_b()
    |> IO.inspect(label: "part_b")
  end

  @beam 2
  @splitter 1
  @empty 0

  def part_a() do
    parse_part(:a)
    |> Grid.new()
    |> simulate(0, 0)
  end

  def part_b() do
    grid =
      parse_part(:a)

    start =
      grid
      |> Enum.at(0)
      |> Enum.find_index(&(&1 == @beam))

    cache = :ets.new(:cache, [:set, :public])

    quantum_simulate(
      grid
      |> Enum.map(&List.to_tuple/1),
      start,
      0,
      cache
    )
  end

  def quantum_simulate([], _, _, _) do
    1
  end

  def quantum_simulate([head | tail], x, y, cache) do
    ans =
      case :ets.lookup(cache, {x, y}) do
        [] ->
          case elem(head, x) do
            @splitter ->
              quantum_simulate(tail, x - 1, y + 1, cache) +
                quantum_simulate(tail, x + 1, y + 1, cache)

            _ ->
              quantum_simulate(tail, x, y + 1, cache)
          end

        [{_, val}] ->
          val
      end

    :ets.insert(cache, {{x, y}, ans})
    ans
  end

  @spec nodify(any()) :: list()
  def nodify(grid) do
    Enum.with_index(grid)
    |> Enum.map(fn {row, y} ->
      Enum.with_index(row)
      |> Enum.map(fn {val, x} -> {y, x, val} end)
    end)
    |> Enum.filter(fn {_, _, val} -> val != @empty end)
  end

  # def simulate([row]) do
  #   Enum.count(row, &(&1 == @beam))
  # end

  # def simulate([row, next_row | rest]) do
  #   next_row_lookup =
  #     Enum.with_index(row)
  #     |> Enum.map(fn {val, idx} -> {idx, val} end)

  #   next_row
  #   |> Enum.with_index()
  #   |> Enum.reduce(fn {val, idx} -> {idx, val} end)
  #   |> Enum.count()
  # end

  def simulate(g, x, y) do
    {y_dim, x_dim} = {g.height, g.width}
    curr = Grid.get(g, {x, y})

    split_count =
      if curr == @beam and y + 1 < y_dim do
        case Grid.get(g, {x, y + 1}) do
          @empty ->
            Grid.put(g, {x, y + 1}, @beam)
            0

          @splitter ->
            if x - 1 >= 0 do
              Grid.put(g, {x - 1, y + 1}, @beam)
            end

            if x + 1 < x_dim do
              Grid.put(g, {x + 1, y + 1}, @beam)
            end

            1

          @beam ->
            0
        end
      else
        0
      end

    split_count +
      case {x, y} do
        {x, y} when x + 1 < x_dim ->
          simulate(g, x + 1, y)

        {_, y} when y + 1 < y_dim ->
          simulate(g, 0, y + 1)

        _ ->
          0
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
  end
end
