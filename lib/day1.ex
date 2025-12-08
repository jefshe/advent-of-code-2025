defmodule Day1 do
  @type input() :: {:left | :right, integer()}

  def run do
    IO.puts("Day 1")

    part_a()
    |> IO.inspect(label: "part_a")

    part_b()
    |> IO.inspect(label: "part_b")
  end

  def part_a do
    parse_part_a()
    |> Enum.reduce({50, 0}, fn {direction, steps}, {pos, cnt} ->
      new_pos =
        case direction do
          :left -> rem(pos - steps + 100, 100)
          :right -> rem(pos + steps, 100)
        end

      {new_pos, cnt + if(new_pos === 0, do: 1, else: 0)}
    end)
  end

  def part_b do
    parse_part_a()
    |> Enum.reduce({50, 0}, fn {direction, steps}, {pos, cnt} ->
      case direction do
        :left -> {positive_mod(pos - steps, 100), cnt + count_revs(pos, -steps)}
        :right -> {positive_mod(pos + steps, 100), cnt + count_revs(pos, steps)}
      end
    end)
  end

  def positive_mod(num, mod_by) do
    res = rem(num, mod_by)
    if(res < 0, do: res + mod_by, else: res)
  end

  @doc """
    Counts the number of times a rotation passes zero (including landing on it)
    ## Examples
      iex> count_revs(50, 150)
      1
      iex> count_revs(50, 250)
      2
  """
  def count_revs(pos, steps) do
    target = pos + steps

    crossing =
      if (pos > 0 and target < 0) or target == 0 do
        1
      else
        0
      end

    crossing + div(abs(target), 100)
  end

  def parse_part_a() do
    Utils.read_file(1, :a)
    |> String.split("\n")
    |> Enum.map(fn line -> String.trim(line) end)
    |> Enum.filter(fn line -> line != "" end)
    |> Enum.map(fn line ->
      <<direction::utf8, rest::binary>> = line

      {case direction do
         ?L -> :left
         ?R -> :right
       end, String.to_integer(rest)}
    end)
  end
end
