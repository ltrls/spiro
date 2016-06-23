defmodule Spiro.Adapter.Digraph do
  @moduledoc """
  Implement graph operations for an Erlang Digraph.
  """

  @behaviour Spiro.Adapter

  alias Spiro.Vertex
  alias Spiro.Edge

  def start_link(opts, module) do
    opts = opts || []
    Agent.start_link(fn -> {:digraph.new(opts), 0, 0} end, name: module)
  end

  def add_vertex(%Vertex{properties: properties} = vertex, module) do
    id = Agent.get_and_update(module, fn
      ({graph, no_v, no_e}) ->
        :digraph.add_vertex(graph, no_v, properties)
        {no_v, {graph, no_v + 1, no_e}}
    end)
    Map.put(vertex, :id, id)
  end

  def add_edge(%Edge{from: from, to: to, properties: properties} = edge, module) do
    id = Agent.get_and_update(module, fn
      ({graph, no_v, no_e}) ->
        :digraph.add_edge(graph, no_e, from.id, to.id, properties)
        {no_e, {graph, no_v, no_e + 1}}
    end)
    Map.put(edge, :id, id)
  end

  def update_vertex(%Vertex{id: id, properties: properties}, module) do
    get_agent(module, &:digraph.add_vertex(&1, id, properties))
  end
  def update_vertex(%Vertex{id: id} = vertex, fun, module) do
    properties = vertex_properties(vertex, module) |> fun.()
    get_agent(module, &:digraph.add_vertex(&1, id, properties))
  end

  def update_edge(%Edge{id: id, properties: properties, from: from, to: to}, module) do
    get_agent(module, &:digraph.add_edge(&1, id, from, to, properties))
  end
  def update_edge(%Edge{id: id, from: from, to: to} = edge, fun, module) do
    properties = edge_properties(edge, module) |> fun.()
    get_agent(module, &:digraph.add_edge(&1, id, from, to, properties))
  end

  def delete_vertex(%Vertex{id: id}, module) do
    get_agent(module, &:digraph.del_vertex(&1, id))
  end

  def delete_edge(%Edge{id: id}, module) do
    get_agent(module, &:digraph.del_edge(&1, id))
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

  def execute(trav), do: []

end
