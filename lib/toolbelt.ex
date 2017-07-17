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

  @doc "Prints all pending messages in the process' mailbox to console"
  @spec flush() :: :ok
  def flush() do
    receive do
      msg -> IO.inspect msg; flush()
    after
      10 -> :ok
    end
  end

  @doc "Times a function"
  @spec time(fun) :: integer
  def time(function) do
    :timer.tc(function)
    |> elem(0)
    |> Kernel./(1_000_000)
  end

  @spec time(fun, list) :: integer
  def time(function, args) do
    :timer.tc(function, args)
    |> elem(0)
    |> Kernel./(1_000_000)
  end

  @spec time(atom, atom, list) :: integer
  def time(module, function, args) do
    :timer.tc(module, function, args)
    |> elem(0)
    |> Kernel./(1_000_000)
  end

  def maybe(nil, _keys), do: nil
  def maybe(val, []), do: val
  def maybe(map, [h|t]) when is_map(map), do: maybe(Map.get(map, h), t)
  def maybe(_, _), do: nil

  def random_string(num_bytes, str_length \\ 0)
  def random_string(num_bytes, 0), do: :crypto.strong_rand_bytes(num_bytes) |> Base.url_encode64
  def random_string(num_bytes, str_length), do: :crypto.strong_rand_bytes(num_bytes) |> Base.url_encode64 |> binary_part(0, str_length)
end
