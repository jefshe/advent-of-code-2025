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
      |> Enum.max()

    area
  end

  def part_b do
    points = parse_part(:a)

    # pairs =
    #   points
    #   |> unique_pairs()
    #   |> Enum.reduce([], fn {{ax, ay} = a, {bx, by} = b}, acc ->
    #     [{(abs(ax - bx) + 1) * (abs(ay - by) + 1), {a, b}} | acc]
    #   end)
    #   |> Enum.sort(:desc)

    polygon = points ++ [hd(points)]

    Enum.map(points, fn p -> {p, polygon_contains(p, polygon)} end)
    |> Enum.reject(fn {_, v} -> v end)

    # Enum.find_value(pairs, fn {area, {a, b}} ->
    #   if polygon_contains(a, polygon) and polygon_contains(b, polygon) do
    #     IO.inspect({a, b})
    #     area
    #   end
    # end)
  end

  @spec polygon_contains({integer(), integer()}, list({integer(), integer()})) :: boolean()
  def polygon_contains(item, polygon) do
    point_on_boundary(item, polygon) or polygon_contains(item, polygon, false)
  end

  @spec polygon_contains({integer(), integer()}, list(), boolean()) :: boolean()
  defp polygon_contains(_, [_], inside), do: inside

  @spec polygon_contains({integer(), integer()}, list({integer(), integer()}), boolean()) ::
          boolean()
  defp polygon_contains({xitem, yitem}, [{x1, y1}, {x2, y2} = next | t], inside) do
    crosses =
      if x1 == x2 do
        x1 > xitem and yitem >= min(y1, y2) and yitem < max(y1, y2)
      else
        false
      end

    if crosses do
      polygon_contains({xitem, yitem}, [next | t], not inside)
    else
      polygon_contains({xitem, yitem}, [next | t], inside)
    end
  end

  # Check if a point lies on any edge of the polygon
  defp point_on_boundary(_, [_]), do: false

  defp point_on_boundary({px, py}, [{x1, y1}, {x2, y2} = next | rest]) do
    on_segment =
      cond do
        # Vertical edge
        x1 == x2 -> px == x1 and py >= min(y1, y2) and py <= max(y1, y2)
        # Horizontal edge
        y1 == y2 -> py == y1 and px >= min(x1, x2) and px <= max(x1, x2)
        true -> false
      end

    on_segment or point_on_boundary({px, py}, [next | rest])
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
