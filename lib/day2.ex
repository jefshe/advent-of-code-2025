defmodule Day2 do
  def run do
    IO.puts("Day 2")

    part_a()
    |> IO.inspect(label: "part_a")

    part_b()
    |> IO.inspect(label: "part_b")
  end

  def part_a do
    parse_part_a()
    |> Enum.map(&num_invalid_a/1)
    |> Enum.sum()
  end

  def part_b do
    parse_part_a()
    |> Enum.map(&num_invalid_b/1)
    |> Enum.sum()
  end

  @spec num_invalid_a({integer(), integer()}) :: integer()
  def num_invalid_a(rng) do
    {min, max} = rng
    Enum.reduce(min..max, 0, fn x, total -> total + if(halves_equal?(x), do: x, else: 0) end)
  end

  @spec num_invalid_b({integer(), integer()}) :: integer()
  def num_invalid_b(rng) do
    {min, max} = rng
    Enum.reduce(min..max, 0, fn x, total -> total + if(is_repeating?(x), do: x, else: 0) end)
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

  @spec is_repeating?(integer()) :: boolean()
  def is_repeating?(num) do
    digits = Integer.digits(num) |> List.to_tuple()
    is_repeating?(digits, 1)
  end

  @spec is_repeating?(tuple(), integer()) :: boolean()
  def is_repeating?(digits, chunk_size) do
    case chunk_size do
      chunk_size when chunk_size > tuple_size(digits) / 2 ->
        false

      chunk_size when rem(tuple_size(digits), chunk_size) != 0 ->
        is_repeating?(digits, chunk_size + 1)

      _ ->
        Enum.all?(0..(tuple_size(digits) - chunk_size)//chunk_size, fn i ->
          Enum.all?(i..(i + chunk_size - 1), fn j ->
            elem(digits, j) == elem(digits, rem(j, chunk_size))
          end)
        end) or is_repeating?(digits, chunk_size + 1)
    end
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
