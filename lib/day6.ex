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
    |> Enum.map(fn {args, op} -> Enum.reduce(args, op) end)
    |> Enum.sum()
  end

  def string_to_op(op) do
    case op do
      "*" -> &*/2
      "+" -> &+/2
    end
  end

  def string_to_int(list) do
    Enum.join(list) |> String.trim() |> String.to_integer()
  end

  @spec parse_part_a(:a | :b | :ex) :: [{[integer()], function()}]
  def parse_part_a(part) do
    Utils.read_file_stream(6, part)
    |> Enum.map(&String.split/1)
    |> Enum.zip()
    |> Enum.map(fn {a, b, c, d, op} ->
      {Enum.map([a, b, c, d], &String.to_integer/1), string_to_op(op)}
    end)
  end

  @spec parse_part_b(:a | :b | :ex) :: [{[integer()], function()}]
  def parse_part_b(part) do
    Utils.read_file_stream_ws(6, part)
    |> Enum.map(&String.graphemes/1)
    |> Enum.zip()
    |> Enum.reject(fn x -> Enum.all?(Tuple.to_list(x), &(&1 == " ")) end)
    |> Enum.chunk_while(
      [],
      fn col, acc ->
        case {col, acc} do
          {{a, b, c, d, op}, []} ->
            {:cont, [string_to_int([a, b, c, d]), op]}

          {{a, b, c, d, op}, _} ->
            if(op != " ",
              do: {:cont, acc, [string_to_int([a, b, c, d]), op]},
              else: {:cont, [string_to_int([a, b, c, d]) | acc]}
            )
        end
      end,
      &{:cont, &1, &1}
    )
    |> Enum.map(&Enum.reverse/1)
    |> Enum.map(fn [op | nums] -> {nums, string_to_op(op)} end)
  end
end
