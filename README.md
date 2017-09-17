# ExploringElixir

Contains code examples used in the Exploring Elixir screencast series:

  https://www.youtube.com/ExploringElixir

Note that this is not a "coherent" Elixir application, but rather the
collection of snippets and modules used in the screencasts.

Code for each episode is typically found in lib/exploring_elixir/e###/

Setup functions for each episode are found in the ExploringElixir module,
so a typical interactive session will look like:

  > iex -S mix
  iex(1)> ExploringElixir.episode1
  .. some output ..
  iex(2)>

At which point you can continue exploring the code for that episode.

Otherwise, the usual `mix do deps.get, compile` should suffice to try it out.
Benchmarks should be run with `MIX_ENV=prod`.

Thanks to everyone who contributes to Elixir and its community, with
a special thanks to the authors of the libraris used in this repository!

