defmodule Utils do
  def read_file(day, part) do
    {:ok, file} = File.read("inputs/day#{day}/#{part}.txt")
    file
  end

  def read_file_stream(day, part, lines_or_bytes \\ :line) do
    File.stream!("inputs/day#{day}/#{part}.txt", lines_or_bytes)
    |> Stream.map(&String.trim/1)
  end

  def read_file_stream_ws(day, part, lines_or_bytes \\ :line) do
    File.stream!("inputs/day#{day}/#{part}.txt", lines_or_bytes)
  end
end
