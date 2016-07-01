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

  def set_vertex_properties(%Vertex{id: id, properties: properties} = vertex, module) do
    get_agent(module, &:digraph.add_vertex(&1, id, properties))
    vertex
  end
  def set_edge_properties(%Edge{id: id, properties: properties, from: from, to: to} = edge, module) do
    get_agent(module, &:digraph.add_edge(&1, id, from.id, to.id, properties))
    edge
  end

  def set_vertex_properties(%Vertex{id: id} = vertex, fun, module) do
    properties = vertex_properties(vertex, module) |> fun.()
    get_agent(module, &:digraph.add_vertex(&1, id, properties))
    %{vertex | properties: properties}
  end
  def set_edge_properties(%Edge{id: id, from: from, to: to} = edge, fun, module) do
    properties = edge_properties(edge, module) |> fun.()
    get_agent(module, &:digraph.add_edge(&1, id, from.id, to.id, properties))
    %{edge | properties: properties}
  end

  def add_vertex_properties(%Vertex{id: id, properties: properties} = vertex, _properties, module) do
    # TODO: not implemented
    get_agent(module, &:digraph.add_vertex(&1, id, properties))
    vertex
  end
  def add_edge_properties(%Edge{id: id, properties: properties, from: from, to: to} = edge, _properties, module) do
    # TODO: not implemented
    get_agent(module, &:digraph.add_edge(&1, id, from.id, to.id, properties))
    edge
  end

  def delete_vertex(%Vertex{id: id}, module) do
    get_agent(module, &:digraph.del_vertex(&1, id))
  end

  def delete_edge(%Edge{id: id}, module) do
    get_agent(module, &:digraph.del_edge(&1, id))
  end

  def vertices(vertices_id, module) do
    all_vertices = get_agent(module, &:digraph.vertices(&1))
    vertices = case vertices_id do
      []   -> all_vertices
      list -> Enum.filter(all_vertices, &(&1 in list))
    end
    Enum.map(vertices, &(%Vertex{id: &1}))
  end

  def edges(edges_id, module) do
    all_edges = get_agent(module, &:digraph.edges(&1))
    edges = case edges_id do
      []   -> all_edges
      list -> Enum.filter(all_edges, &(&1 in list))
    end
    Enum.map(edges, &(%Edge{id: &1}))
  end

  def vertex_properties(%Vertex{id: id}, module) do
    with {_id, properties} = get_agent(module, &:digraph.vertex(&1, id)), do: properties
  end

  def edge_properties(%Edge{id: id}, module) do
    with {_id, _e1, _e2, properties} = get_agent(module, &:digraph.edge(&1, id)), do: properties
  end
  
  def get_vertex_property(%Vertex{id: id}, key, module) do
    with {_id, properties} = get_agent(module, &:digraph.vertex(&1, id)), do: properties[key]
  end
  
  def get_edge_property(%Edge{id: id}, key, module) do
    with {_id, _e1, _e2, properties} = get_agent(module, &:digraph.edge(&1, id)), do: properties[key]
  end
  
  def set_vertex_property(%Vertex{id: id} = vertex, key, value, module) do
    with {_id, properties} = get_agent(module, &:digraph.vertex(&1, id)), do: set_vertex_properties %{vertex | properties: Keyword.put(properties, key, value)}, module
  end
  
  def set_edge_property(%Edge{id: id} = edge, key, value, module) do
    with {_id, _e1, _e2, properties} = get_agent(module, &:digraph.edge(&1, id)), do: set_edge_properties %{edge | properties: Keyword.put(properties, key, value)}, module
  end

  def edge_endpoints(%Edge{id: id}, module) do
    with {_id, e1, e2, _properties} = get_agent(module, &:digraph.edge(&1, id)), do: {%Vertex{id: e1}, %Vertex{id: e2}}
  end

  def vertex_degree(%Vertex{id: id}, direction, _types, module) do
    fun = case direction do
      :in -> &:digraph.in_degree/2
      :out -> &:digraph.out_degree/2
      :all -> &(:digraph.in_degree(&1, &2) + :digraph.out_degree(&1, &2))
    end
    get_agent(module, &fun.(&1, id))
  end

  def adjacent_edges(%Vertex{id: id}, direction, _types, module) do
    fun = case direction do
      :in -> &:digraph.in_edges/2
      :out -> &:digraph.out_edges/2
      :all -> &(:digraph.in_edges(&1, &2) ++ :digraph.out_edges(&1, &2))
    end
    Enum.map(get_agent(module, &fun.(&1, id)), &(%Edge{id: &1}))
  end

  def vertex_neighbours(%Vertex{id: id}, direction, _types, module) do
    fun = case direction do
      :in -> &:digraph.in_neighbours/2
      :out -> &:digraph.out_neighbours/2
      :all -> &(:digraph.in_neighbours(&1, &2) ++ :digraph.out_neighbours(&1, &2))
    end
    Enum.map(get_agent(module, &fun.(&1, id)), &(%Vertex{id: &1}))
  end

  @type digraph_types :: integer | list(integer) | tuple | true
  @spec get_agent(module, (:digraph.graph() -> digraph_types)) :: digraph_types
  defp get_agent(module, fun) do
    Agent.get(module, fn
      {graph, _, _} -> fun.(graph)
    end)
  end

  def execute(_trav), do: []

  def supported_functions, do: %{}

end
