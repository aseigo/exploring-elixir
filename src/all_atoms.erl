-module(all_atoms).

-export([all_atoms/0]).

atom_by_number(N) ->
  binary_to_term(<<131,75,N:24>>).

all_atoms() ->
  atoms_starting_at(0).

atoms_starting_at(N) ->
  try atom_by_number(N) of
    Atom ->
      [Atom] ++ atoms_starting_at(N + 1)
  catch
    error:badarg ->
      []
  end.
