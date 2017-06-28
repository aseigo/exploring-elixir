defmodule Toolbelt do

  @moduledoc "A collection of useful snippets of Elixir"

  @doc """
  Prints the full set of metadata for a module, as known to Module:__info__.

  Returns: `:ok`.
  """
  @spec print_module_info(atom) :: :ok
  def print_module_info(modulename) do
    info_attrs = [:attributes, :compile, :exports, :functions, :macros, :md5, :module, :native_addresses]
    attr_printer = fn x -> IO.puts "== #{x}"; IO.inspect apply(modulename,  :__info__, [x]) end

    Enum.each info_attrs, attr_printer
  end

  def flush() do
    receive do
      msg -> IO.inspect msg; flush()
    after
      10 -> :ok
    end
  end

  def maybe(nil, _keys), do: nil
  def maybe(val, []), do: val
  def maybe(map, [h|t]) when is_map(map), do: maybe(Map.get(map, h), t)
  def maybe(_, _), do: nil
end
