defmodule Spiro.Adapter do
  @moduledoc """
  Provides base for graph system adapters.
  """

  @callback addV(Spiro.Traversal.t) :: Spiro.Traversal.t
  @callback addE(Spiro.Traversal.t) :: Spiro.Traversal.t
  @callback property(Spiro.Traversal.t) :: Spiro.Traversal.t
  @callback aggregate(Spiro.Traversal.t) :: Spiro.Traversal.t
  @callback as(Spiro.Traversal.t) :: Spiro.Traversal.t
  @callback barrier(Spiro.Traversal.t) :: Spiro.Traversal.t
  @callback as(Spiro.Traversal.t) :: Spiro.Traversal.t
  @callback by(Spiro.Traversal.t) :: Spiro.Traversal.t
  @callback cap(Spiro.Traversal.t) :: Spiro.Traversal.t
  @callback coalesce(Spiro.Traversal.t) :: Spiro.Traversal.t
  @callback count(Spiro.Traversal.t) :: Spiro.Traversal.t
  @callback choose(Spiro.Traversal.t) :: Spiro.Traversal.t
  @callback coin(Spiro.Traversal.t) :: Spiro.Traversal.t
  @callback constant(Spiro.Traversal.t) :: Spiro.Traversal.t
  @callback cyclicPath(Spiro.Traversal.t) :: Spiro.Traversal.t
  @callback dedup(Spiro.Traversal.t) :: Spiro.Traversal.t
  @callback drop(Spiro.Traversal.t) :: Spiro.Traversal.t
  @callback explain(Spiro.Traversal.t) :: Spiro.Traversal.t
  @callback fold(Spiro.Traversal.t) :: Spiro.Traversal.t
  @callback group(Spiro.Traversal.t) :: Spiro.Traversal.t
  @callback groupCount(Spiro.Traversal.t) :: Spiro.Traversal.t
  @callback has(Spiro.Traversal.t) :: Spiro.Traversal.t
  @callback hasLabel(Spiro.Traversal.t) :: Spiro.Traversal.t
  @callback hasId(Spiro.Traversal.t) :: Spiro.Traversal.t
  @callback hasKey(Spiro.Traversal.t) :: Spiro.Traversal.t
  @callback hasValue(Spiro.Traversal.t) :: Spiro.Traversal.t
  @callback hasNot(Spiro.Traversal.t) :: Spiro.Traversal.t
  @callback inject(Spiro.Traversal.t) :: Spiro.Traversal.t
  @callback is(Spiro.Traversal.t) :: Spiro.Traversal.t
  @callback limit(Spiro.Traversal.t) :: Spiro.Traversal.t
  @callback local(Spiro.Traversal.t) :: Spiro.Traversal.t
  @callback match(Spiro.Traversal.t) :: Spiro.Traversal.t
  @callback max(Spiro.Traversal.t) :: Spiro.Traversal.t
  @callback mean(Spiro.Traversal.t) :: Spiro.Traversal.t
  @callback min(Spiro.Traversal.t) :: Spiro.Traversal.t
  @callback order(Spiro.Traversal.t) :: Spiro.Traversal.t
  @callback path(Spiro.Traversal.t) :: Spiro.Traversal.t
  @callback profile(Spiro.Traversal.t) :: Spiro.Traversal.t
  @callback range(Spiro.Traversal.t) :: Spiro.Traversal.t
  @callback repeat(Spiro.Traversal.t) :: Spiro.Traversal.t
  @callback sack(Spiro.Traversal.t) :: Spiro.Traversal.t
  @callback sample(Spiro.Traversal.t) :: Spiro.Traversal.t
  @callback select(Spiro.Traversal.t) :: Spiro.Traversal.t
  @callback simplePath(Spiro.Traversal.t) :: Spiro.Traversal.t
  @callback store(Spiro.Traversal.t) :: Spiro.Traversal.t
  @callback subGraph(Spiro.Traversal.t) :: Spiro.Traversal.t
  @callback sum(Spiro.Traversal.t) :: Spiro.Traversal.t
  @callback tail(Spiro.Traversal.t) :: Spiro.Traversal.t
  @callback timeLimit(Spiro.Traversal.t) :: Spiro.Traversal.t
  @callback tree(Spiro.Traversal.t) :: Spiro.Traversal.t
  @callback unfold(Spiro.Traversal.t) :: Spiro.Traversal.t
  @callback union(Spiro.Traversal.t) :: Spiro.Traversal.t
  @callback valueMap(Spiro.Traversal.t) :: Spiro.Traversal.t
  @callback out(Spiro.Traversal.t) :: Spiro.Traversal.t
  @callback both(Spiro.Traversal.t) :: Spiro.Traversal.t
  @callback outE(Spiro.Traversal.t) :: Spiro.Traversal.t
  @callback inE(Spiro.Traversal.t) :: Spiro.Traversal.t
  @callback bothE(Spiro.Traversal.t) :: Spiro.Traversal.t
  @callback outV(Spiro.Traversal.t) :: Spiro.Traversal.t
  @callback inV(Spiro.Traversal.t) :: Spiro.Traversal.t
  @callback bothV(Spiro.Traversal.t) :: Spiro.Traversal.t
  @callback otherV(Spiro.Traversal.t) :: Spiro.Traversal.t
  @callback where(Spiro.Traversal.t) :: Spiro.Traversal.t

  #@callback and(Spiro.Traversal.t) :: Spiro.Traversal.t
  #@callback or(Spiro.Traversal.t) :: Spiro.Traversal.t
  #@callback in(Spiro.Traversal.t) :: Spiro.Traversal.t
end
