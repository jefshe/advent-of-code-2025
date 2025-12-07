defmodule Utils do
  def read_file(day, part) do
    {:ok, file} = File.read("inputs/day#{day}/#{part}.txt")
    file
  end
end
