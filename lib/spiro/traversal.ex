defmodule Spiro.Traversal do
  @moduledoc """
  Implementing the TinkerPop/Gremlin traversal API, found here:

  http://tinkerpop.apache.org/docs/3.1.1-incubating/reference/#traversal
  """

  defstruct steps: []
  use ExConstructor

  alias Spiro.Traversal.Step

  def vertices(trav, ids \\ []) when is_list(ids), do: addStep(trav, :V, %{ids: ids})
  def edges(trav, ids \\ []) when is_list(ids), do: addStep(trav, :E, %{ids: ids})

  def addE(trav, label), do: addStep(trav, :addE, %{label: label})
  def addV(trav, label), do: addStep(trav, :addV, %{label: label})

  def has(trav, key), do: addStep(trav, :has, %{key: key})
  def has(trav, key, value), do: addStep(trav, :has, %{key: key, value: value})
  def hasLabel(trav, labels) when is_list(labels), do: addStep(trav, :hasLabel, %{labels: labels})
  def hasId(trav, ids) when is_list(ids), do: addStep(trav, :hasId, %{ids: ids})
  def hasKey(trav, keys) when is_list(keys), do: addStep(trav, :hasKey, %{keys: keys})
  def hasValue(trav, values) when is_list(values), do: addStep(trav, :hasValue, %{values: values})
  def hasNot(trav, key), do: addStep(trav, :hasNot, %{key: key})

  def out(trav, labels \\ []) when is_list(labels), do: addStep(trav, :out, %{labels: labels})
  def both(trav, labels \\ []) when is_list(labels), do: addStep(trav, :both, %{labels: labels})
  def outE(trav, labels \\ []) when is_list(labels), do: addStep(trav, :outE, %{labels: labels})
  def inE(trav, labels \\ []) when is_list(labels), do: addStep(trav, :inE, %{labels: labels})
  def bothE(trav, labels \\ []) when is_list(labels), do: addStep(trav, :bothE, %{labels: labels})
  def outV(trav), do: addStep(trav, :outV)
  def inV(trav), do: addStep(trav, :inV)
  def bothV(trav), do: addStep(trav, :bothV)
  def otherV(trav), do: addStep(trav, :otherV)

  def limit(trav, count), do: addStep(trav, :limit, %{count: count})
  def max(trav), do: addStep(trav, :max)
  def mean(trav), do: addStep(trav, :mean)
  def min(trav), do: addStep(trav, :min)
  def order(trav), do: addStep(trav, :order)
  def path(trav), do: addStep(trav, :path)
  def property(trav, key, value), do: addStep(trav, :property, %{key: key, value: value})
  def range(trav, low, high), do: addStep(trav, :range, %{low: low, high: high})
  def sum(trav), do: addStep(trav, :sum)
  def tail(trav, count \\ 1), do: addStep(trav, :tail, %{count: count})
  def timeLimit(trav, timeout), do: addStep(trav, :timeLimit, %{timeout: timeout})
  def values(trav, keys \\ []) when is_list(keys), do: addStep(trav, :values, %{keys: keys})

  # TODO http://tinkerpop.apache.org/docs/3.1.1-incubating/reference/#match-step
  #def match(trav, params), do: trav
  #def select(trav, params), do: addStep(trav, :select, %{params: params})
  #def where(trav, predicate), do: addStep(trav, :where, %{predicate: predicate})

  # TODO Symbols are ambiguous/reserved.
  #def and(trav, params), do: trav
  #def in(trav, labels \\ []), do: addStep(trav, :in, %{labels: labels})
  #def or(trav, params), do: trav

  # TODO Unclear as to how to proceed with these atm.
  #def choose(trav, params), do: trav
  #def coalesce(trav, params), do: trav
  #def groupCount(trav, params), do: trav
  #def inject(trav, params), do: trav
  #def local(trav, params), do: trav
  #def profile(trav, params), do: trav
  #def sack(trav, params), do: trav
  #def store(trav, params), do: trav
  #def tree(trav, params), do: trav
  #def union(trav, params), do: trav
  #def aggregate(trav, key), do: addStep(trav, :aggregate, %{key: key})
  #def as(trav, label), do: addStep(trav, :as, %{label: label})
  #def barrier(trav, limit \\ nil), do: addStep(trav, :barrier, %{limit: limit})
  #def by(trav, predicate), do: addStep(trav, :by, %{predicate: predicate})
  #def cap(trav, label), do: addStep(trav, :cap, %{label: label})
  #def coin(trav, bias), do: addStep(trav, :coin, %{bias: bias})
  #def constant(trav, value), do: addStep(trav, :constant, %{value: value})
  #def count(trav), do: addStep(trav, :count)
  #def cyclicPath(trav), do: addStep(trav, :cyclicPath)
  #def dedup(trav, params \\ []), do: addStep(trav, :dedup, %{params: params})
  #def drop(trav), do: addStep(trav, :drop)
  #def explain(trav), do: addStep(trav, :explain)
  #def fold(trav), do: addStep(trav, :fold)
  #def fold(trav, seed, reducer), do: addStep(trav, :fold, %{seed: seed, reducer: reducer})
  #def group(trav), do: addStep(trav, :group)
  #def is(trav, predicate), do: addStep(trav, :is, %{predicate: predicate})
  #def repeat(trav, predicate), do: addStep(trav, :repeat, %{predicate: predicate})
  #def sample(trav, count), do: addStep(trav, :sample, %{count: count})
  #def simplePath(trav), do: addStep(trav, :simplePath)
  #def subGraph(trav, name), do: addStep(trav, :subGraph, %{name: name})
  #def unfold(trav), do: addStep(trav, :unfold)
  #def valueMap(trav, keys \\ []), do: addStep(trav, :valueMap, %{keys: keys})

  def getSteps(trav) do
    Enum.reverse(trav.steps)
  end

  @doc false
  defp addStep(%Spiro.Traversal{} = trav, type, params \\ %{}) do
    Map.put(trav, :steps, [Step.new(type: type, params: params) | trav.steps])
  end
end
