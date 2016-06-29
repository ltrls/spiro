defmodule Spiro.Adapter do
  @moduledoc """
  Provides base for graph system adapters.
  """
  # http://tinkerpop.apache.org/javadocs/3.0.2-incubating/core/index.html?org/apache/tinkerpop/gremlin/process/traversal/dsl/graph/GraphTraversal.html

  @type ok_tuple(t) :: {:ok, t} | {:error, String.t}

  # TODO: fn without ! -> tuple() ;;;;; fn with ! -> elem or raise
  @callback add_vertex(Spiro.Vertex.t, module) :: Spiro.Vertex.t
  # @callback add_vertex(Spiro.Vertex.t, module) :: ok_tuple(Spiro.Vertex.t)
  @callback add_edge(Spiro.Edge.t, module) :: Spiro.Edge.t
  # @callback add_edge(Spiro.Edge.t, module) :: ok_tuple(Spiro.Edge.t)
  @callback update_vertex(Spiro.Vertex.t, module) :: Spiro.Vertex.t
  @callback update_edge(Spiro.Edge.t, module) :: Spiro.Edge.t
  @callback delete_vertex(Spiro.Vertex.t, module) :: true
  @callback delete_edge(Spiro.Edge.t, module) :: true
  @callback vertex_properties(Spiro.Vertex.t, module) :: keyword
  @callback edge_properties(Spiro.Edge.t, module) :: keyword
  @callback get_vertex_property(Spiro.Vertex.t, String.t, module) :: term
  @callback get_edge_property(Spiro.Edge.t, String.t, module) :: term
  @callback set_vertex_property(Spiro.Vertex.t, String.t, term, module) :: none
  @callback set_edge_property(Spiro.Edge.t, String.t, term, module) :: none
  @callback vertices(module) :: list(Spiro.Vertex.Vertex)
  @callback edges(module) :: list(Spiro.Edge.t)

  @callback list_labels(module) :: list(String.t)
  @callback list_types(module) :: list(String.t)
  @callback vertices_by_label(String.t, module) :: list(Spiro.Vertex.t)
  @callback get_labels(Spiro.Vertex.t, module) :: list(String.t)
  @callback add_labels(Spiro.Vertex.t, list(String.t), module) :: Spiro.Vertex.t
  @callback set_labels(Spiro.Vertex.t, module) :: Spiro.Vertex.t
  @callback remove_label(Spiro.Vertex.t, String.t, module) :: none


  @callback node_degree(Spiro.Vertex.t, (:in | :out | :all), list(String.t), module) :: pos_integer
  @callback adjacent_edges(Spiro.Vertex.t, (:in | :out | :all), list(String.t), module) :: list(Spiro.Edge.t)
  @callback node_neighbours(Spiro.Vertex.t, (:in | :out | :all), list(String.t), module) :: list(Spiro.Vertex.t)

  @callback execute(Spiro.Traversal.t, module) :: tuple
  @callback execute!(Spiro.Traversal.t, module) :: list

  @optional_callbacks list_labels: 1,
                      list_types: 1,
                      vertices_by_label: 2,
                      get_labels: 2,
                      add_labels: 3,
                      set_labels: 2,
                      remove_label: 3


  @callback supported_functions() :: map

  def supports_function?(adapter, function) do
    case adapter.supported_functions() do
      %{^function => :true} -> :true
      _ -> :false
    end
  end

end
