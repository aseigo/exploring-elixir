# Shamelessly borrowed from Magnus Henoch's fantastic Erlang Solutions article:
#  https://www.erlang-solutions.com/blog/erlang-and-elixir-distribution-without-epmd.html
# You want to read that! :)
# To use this, you will want to run dist.sh from the top level directory of this project

defmodule ExploringElixir.Dist.Service do
  def port(name) when is_atom(name) do
    port Atom.to_string name
  end

  def port(name) when is_list(name) do
    port List.to_string name
  end

  def port(name) when is_binary(name) do
    # Figure out the base port.  If not specified using the
    # inet_dist_base_port kernel environment variable, default to
    # 4370, one above the epmd port.
    base_port = :application.get_env :kernel, :inet_dist_base_port, 4370

    # Now, figure out our "offset" on top of the base port.  The
    # offset is the integer just to the left of the @ sign in our node
    # name.  If there is no such number, the offset is 0.
    #
    # Also handle the case when no hostname was specified.
    node_name = Regex.replace ~r/@.*$/, name, ""
    offset =
      case Regex.run ~r/[0-9]+$/, node_name do
    nil ->
      0
    [offset_as_string] ->
      String.to_integer offset_as_string
      end

    base_port + offset
  end
end

defmodule ExploringElixir.Dist.Service_dist do

  def listen(name) do
    # Here we figure out what port we want to listen on.

    port = ExploringElixir.Dist.Service.port name

    # Set both "min" and "max" variables, to force the port number to
    # this one.
    :ok = :application.set_env :kernel, :inet_dist_listen_min, port
    :ok = :application.set_env :kernel, :inet_dist_listen_max, port

    # Finally run the real function!
    :inet_tcp_dist.listen name
  end

  def select(node) do
    :inet_tcp_dist.select node
  end

  def accept(listen) do
    :inet_tcp_dist.accept listen
  end

  def accept_connection(accept_pid, socket, my_node, allowed, setup_time) do
    IO.puts "Accepting connection! #{inspect my_node}"
    :inet_tcp_dist.accept_connection accept_pid, socket, my_node, allowed, setup_time
  end

  def setup(node, type, my_node, long_or_short_names, setup_time) do
    :inet_tcp_dist.setup node, type, my_node, long_or_short_names, setup_time
  end

  def close(listen) do
    :inet_tcp_dist.close listen
  end

  def childspecs do
    :inet_tcp_dist.childspecs
  end
end

defmodule ExploringElixir.Dist.Client do
  # erl_distribution wants us to start a worker process.  We don't
  # need one, though.
  def start_link do
    :ignore
  end

  # As of Erlang/OTP 19.1, register_node/3 is used instead of
  # register_node/2, passing along the address family, 'inet_tcp' or
  # 'inet6_tcp'.  This makes no difference for our purposes.
  def register_node(name, port, _family) do
    register_node(name, port)
  end

  def register_node(_name, _port) do
    # This is where we would connect to epmd and tell it which port
    # we're listening on, but since we're epmd-less, we don't do that.

    # Need to return a "creation" number between 1 and 3.
    creation = :rand.uniform 3
    {:ok, creation}
  end

  def port_please(name, _ip) do
    port = ExploringElixir.Dist.Service.port name
    # The distribution protocol version number has been 5 ever since
    # Erlang/OTP R6.
    version = 5
    {:port, port, version}
  end

  def names(_hostname) do
    # Since we don't have epmd, we don't really know what other nodes
    # there are.
    {:error, :address}
  end
end
