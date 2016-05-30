defmodule Spiro.Adapter.Digraph do
  @moduledoc """
  Implement graph operations for an Erlang Digraph.
  """

  # Implement the adapter behaviour for this graph type.
  @behaviour Spiro.Adapter
  def addV(trav), do: trav
  def addE(trav), do: trav
  def property(trav), do: trav
  def aggregate(trav), do: trav
  def as(trav), do: trav
  def barrier(trav), do: trav
  def by(trav), do: trav
  def cap(trav), do: trav
  def coalesce(trav), do: trav
  def count(trav), do: trav
  def choose(trav), do: trav
  def coin(trav), do: trav
  def constant(trav), do: trav
  def cyclicPath(trav), do: trav
  def dedup(trav), do: trav
  def drop(trav), do: trav
  def explain(trav), do: trav
  def fold(trav), do: trav
  def group(trav), do: trav
  def groupCount(trav), do: trav
  def has(trav), do: trav
  def hasLabel(trav), do: trav
  def hasId(trav), do: trav
  def hasKey(trav), do: trav
  def hasValue(trav), do: trav
  def hasNot(trav), do: trav
  def inject(trav), do: trav
  def is(trav), do: trav
  def limit(trav), do: trav
  def local(trav), do: trav
  def match(trav), do: trav
  def max(trav), do: trav
  def mean(trav), do: trav
  def min(trav), do: trav
  def order(trav), do: trav
  def path(trav), do: trav
  def profile(trav), do: trav
  def range(trav), do: trav
  def repeat(trav), do: trav
  def sack(trav), do: trav
  def sample(trav), do: trav
  def select(trav), do: trav
  def simplePath(trav), do: trav
  def store(trav), do: trav
  def subGraph(trav), do: trav
  def sum(trav), do: trav
  def tail(trav), do: trav
  def timeLimit(trav), do: trav
  def tree(trav), do: trav
  def unfold(trav), do: trav
  def union(trav), do: trav
  def valueMap(trav), do: trav
  def out(trav), do: trav
  def both(trav), do: trav
  def outE(trav), do: trav
  def inE(trav), do: trav
  def bothE(trav), do: trav
  def outV(trav), do: trav
  def inV(trav), do: trav
  def bothV(trav), do: trav
  def otherV(trav), do: trav
  def where(trav), do: trav

end
