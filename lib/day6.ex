defmodule Day6 do
  def run do
    IO.puts("Day 6")

    part_a()
    |> IO.inspect(label: "part_a")

    part_b()
    |> IO.inspect(label: "part_b")
  end

  def part_a do
    parse_part_a(:a)
    |> Enum.map(fn {args, op} -> Enum.reduce(args, op) end)
    |> Enum.sum()
  end

  def part_b do
    parse_part_b(:a)
  end

  def string_to_op(op) do
    case op do
      "*" -> &*/2
      "+" -> &+/2
    end
  end

  @spec parse_part_a(:a | :b | :ex) :: [{[integer()], String.t()}]
  def parse_part_a(part) do
    Utils.read_file_stream(6, part)
    |> Enum.map(&String.split/1)
    |> Enum.zip()
    |> Enum.map(fn {a, b, c, d, op} ->
      {Enum.map([a, b, c, d], &String.to_integer/1), string_to_op(op)}
    end)
  end
end
