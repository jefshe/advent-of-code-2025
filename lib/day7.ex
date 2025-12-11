defprotocol  AOCDay, for: Day7 do
  def run do
    IO.puts("Day 7")

    part_a()
    |> IO.inspect(label: "part_a")

    part_b()
    |> IO.inspect(label: "part_b")
  end

  def part_a do
    parse_part(:ex)
  end

  def part_b do
  end

  @spec parse_part(:a | :b | :ex) :: {[Range.t()], [integer()]}
  def parse_part(part) do
    Utils.read_file_stream(7, part)
    # |> Enum.map(&String.to_charlist/1)
    |> Enum.map(
      &Enum.map(&1, fn c ->
        case(c) do
          ?. -> 0
          ?S -> -1
          ?^ -> 1
        end
      end)
    )
    |> Nx.tensor(names: [:y, :x])
  end
end
