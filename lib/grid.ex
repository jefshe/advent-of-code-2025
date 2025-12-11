defmodule ETSGrid do
  def new(width, height) do
    table = :ets.new(:grid, [:set, :public])
    :ets.insert(table, {:dimensions, {width, height}})
    table
  end

  def put(table, {x, y}, value) do
    [{:dimensions, {w, h}}] = :ets.lookup(table, :dimensions)
    if x >= 0 and x < w and y >= 0 and y < h do
      :ets.insert(table, {{x, y}, value})
      :ok
    else
      {:error, :out_of_bounds}
    end
  end

  def put_many(table, coords , value) do
    Enum.map(coords, fn {x,y} -> put(table, {x,y}, value) end)
  end
end
