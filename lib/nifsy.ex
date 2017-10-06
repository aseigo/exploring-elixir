defmodule NativeFile do
  def stream(path) do
    Nifsy.stream!(path)
    |> IO.inspect
  end
end
