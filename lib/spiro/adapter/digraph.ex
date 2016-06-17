defmodule Spiro.Adapter.Digraph do
  @moduledoc """
  Implement graph operations for an Erlang Digraph.
  """

  # Implement the adapter behaviour for this graph type.
  @behaviour Spiro.Adapter

  alias Spiro.Vertex
  alias Spiro.Edge

  def start_link(opts, module) do
    opts = opts || []
    Agent.start_link(fn -> {:digraph.new(opts), 0, 0} end, name: module)
  end

  def add_vertex(v, module) do
    id = Agent.get_and_update(module, fn
      ({graph, no_v, no_e}) ->
        :digraph.add_vertex(graph, no_v, v.properties)
        {no_v, {graph, no_v + 1, no_e}}
    end)
    Map.put(v, :id, id)
  end

  def add_edge(e, v1, v2, module) do
    id = Agent.get_and_update(module, fn
      ({graph, no_v, no_e}) ->
        :digraph.add_edge(graph, no_e, v1.id, v2.id, e.properties)
        {no_e, {graph, no_v, no_e + 1}}
    end)
    Map.put(e, :id, id)
  end

  def vertices(module) do
    Enum.map(get_agent(module, &:digraph.vertices(&1)), &(%Vertex{id: &1}))
  end

  def edges(module) do
    Enum.map(get_agent(module, &:digraph.edges(&1)), &(%Edge{id: &1}))
  end

  def vertex_properties(%Vertex{id: id}, module) do
    with {_id, properties} = get_agent(module, &:digraph.vertex(&1, id)), do: properties
  end

  def edge_properties(%Edge{id: id}, module) do
    with {_id, _e1, _e2, properties} = get_agent(module, &:digraph.edge(&1, id)), do: properties
  end

  def edge_endpoints(%Edge{id: id}, module) do
    with {_id, e1, e2, _properties} = get_agent(module, &:digraph.edge(&1, id)), do: {%Vertex{id: e1}, %Vertex{id: e2}}
  end

  def in_degree(%Vertex{id: id}, module) do
    get_agent(module, &:digraph.in_degree(&1, id))
  end

  def out_degree(%Vertex{id: id}, module) do
    get_agent(module, &:digraph.out_degree(&1, id))
  end

  def in_edges(%Vertex{id: id}, module) do
    Enum.map(get_agent(module, &:digraph.in_edges(&1, id)), &(%Edge{id: &1}))
  end

  def out_edges(%Vertex{id: id}, module) do
    Enum.map(get_agent(module, &:digraph.out_edges(&1, id)), &(%Edge{id: &1}))
  end

  def in_neighbours(%Vertex{id: id}, module) do
    Enum.map(get_agent(module, &:digraph.in_neighbours(&1, id)), &(%Vertex{id: &1}))
  end

  def out_neighbours(%Vertex{id: id}, module) do
    Enum.map(get_agent(module, &:digraph.out_neighbours(&1, id)), &(%Vertex{id: &1}))
  end

  defp get_agent(module, fun) do
    Agent.get(module, fn
      {graph, _, _} -> fun.(graph)
    end)
  end

  # def addV(trav), do: trav
  # def addE(trav), do: trav
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
