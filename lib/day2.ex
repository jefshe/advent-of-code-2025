defmodule Day2 do
  def run do
    IO.puts("Day 2")

    part_a()
    |> IO.inspect(label: "part_a")
  end

  def part_a do
    parse_part_a()
    |> Enum.map(&num_invalid_a/1)
    |> Enum.sum()
  end

  @spec num_invalid_a({integer(), integer()}) :: integer()
  def num_invalid_a(rng) do
    {min, max} = rng
    Enum.reduce(min..max, 0, fn x, total -> total + if(halves_equal?(x), do: x, else: 0) end)
  end

  @spec halves_equal?(integer()) :: boolean()
  def halves_equal?(num) do
    magnitude = :math.log10(num) |> ceil()

    if rem(magnitude, 2) == 0 do
      a = div(num, 10 ** div(magnitude, 2))
      b = rem(num, 10 ** div(magnitude, 2))
      a == b
    else
      false
    end
  end

  def part_b do
  end

  def parse_part_a() do
    Utils.read_file(2, :a)
    |> String.split(",")
    |> Enum.map(fn rng ->
      String.split(String.trim(rng), "-")
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.map(&List.to_tuple/1)
  end
end
