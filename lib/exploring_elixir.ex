defmodule ExploringElixir do
  def episode1 do
    # Emulates a hypothetical service (web service, over a TCP socket,
    # another OTP process, etc.) that transforms some JSON for us ...
    # but which suffers from some bugs?
    f = File.read!("data/client.json")
    ExploringElixir.JSONFilter.extract self(), f, "data"
    Toolbelt.flush()
  end
end
