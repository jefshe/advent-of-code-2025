defmodule Grid do
  defstruct [:table, :width, :height]

  def new(width, height) do
    table = :ets.new(:grid, [:set, :public])
    # Store dimensions in the struct instead of ETS for easier access,
    # or keep both. For inspect, having them in the struct is handy.
    %Grid{table: table, width: width, height: height}
  end

  def new(list) do
    height = Enum.count(list)
    width = Enum.count(hd(list))
    grid = new(width, height)

    Enum.with_index(list)
    |> Enum.each(fn {row, y} ->
      Enum.with_index(row)
      |> Enum.each(fn {val, x} -> put(grid, {x, y}, val) end)
    end)

    grid
  end

  def put(%Grid{table: table, width: w, height: h} = grid, {x, y}, value) do
    if x >= 0 and x < w and y >= 0 and y < h do
      :ets.insert(table, {{x, y}, value})
      {:ok, grid}
    else
      {:error, :out_of_bounds}
    end
  end

  def put_many(grid, coords, value) do
    Enum.each(coords, fn {x, y} -> put(grid, {x, y}, value) end)
    grid
  end

  def get(%Grid{table: table}, {x, y}) do
    case :ets.lookup(table, {x, y}) do
      [{_, val}] -> val
      [] -> nil
    end
  end
end

defimpl Inspect, for: Grid do
  import Inspect.Algebra

  def inspect(%Grid{width: w, height: h} = grid, _opts) do
    # You might want to customize how nil or specific values are printed.
    # For now, printing the raw value using inspect.
    rows =
      for y <- 0..(h - 1) do
        row_str =
          for x <- 0..(w - 1) do
            val = Grid.get(grid, {x, y})
            # Convert value to string representation.
            # If values are integers/strings, to_string might be better.
            # If they are arbitrary terms, inspect(val) is safer.
            # Adjust padding as needed for alignment.
            inspect(val)
          end
          |> Enum.join(" ")

        "\n  " <> row_str
      end

    concat(["#Grid<#{w}x#{h}>", concat(rows)])
  end
end
