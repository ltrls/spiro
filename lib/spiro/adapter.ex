defmodule Spiro.Adapter do
  @moduledoc """
  Provides base for graph system adapters.
  """

  # TODO: fn without ! -> tuple() ;;;;; fn with ! -> elem or raise
  @callback add_vertex(Spiro.Vertex.t, module) :: Spiro.Vertex.t
  @callback add_edge(Spiro.Edge.t, module) :: Spiro.Edge.t
  @callback update_vertex(Spiro.Vertex.t, module) :: Spiro.Vertex.t
  @callback update_edge(Spiro.Edge.t, module) :: Spiro.Edge.t
  @callback delete_vertex(Spiro.Vertex.t, module) :: none
  @callback delete_edge(Spiro.Edge.t, module) :: none
  @callback vertex_properties(Spiro.Vertex.t, module) :: keyword
  @callback edge_properties(Spiro.Edge.t, module) :: keyword
  @callback get_vertex_property(Spiro.Vertex.t, String.t, module) :: term
  @callback get_edge_property(Spiro.Edge.t, String.t, module) :: term
  @callback set_vertex_property(Spiro.Vertex.t, String.t, term, module) :: none
  @callback set_edge_property(Spiro.Edge.t, String.t, term, module) :: none

  @callback list_labels(module) :: list(String.t)
  @callback list_types(module) :: list(String.t)
  @callback vertices_by_label(String.t, module) :: list(Spiro.Vertex.t)
  @callback get_labels(Spiro.Vertex.t, module) :: list(String.t)
  @callback add_labels(Spiro.Vertex.t, list(String.t), module) :: Spiro.Vertex.t
  @callback set_labels(Spiro.Vertex.t, module) :: Spiro.Vertex.t
  @callback remove_label(Spiro.Vertex.t, String.t, module) :: none

  @callback all_degree(Spiro.Vertex.t, list(String.t), module) :: pos_integer
  @callback in_degree(Spiro.Vertex.t, list(String.t), module) :: pos_integer
  @callback out_degree(Spiro.Vertex.t, list(String.t), module) :: pos_integer
  @callback all_edges(Spiro.Vertex.t, list(String.t), module) :: list(Spiro.Edge.t)
  @callback in_edges(Spiro.Vertex.t, list(String.t), module) :: list(Spiro.Edge.t)
  @callback out_edges(Spiro.Vertex.t, list(String.t), module) :: list(Spiro.Edge.t)

  @optional_callbacks list_labels: 1,
                      list_types: 1,
                      vertices_by_label: 2,
                      get_labels: 2,
                      add_labels: 3,
                      set_labels: 2,
                      remove_label: 3

  # @callback add_vertex!(Spiro.Vertex.t) :: Spiro.Vertex.t
  # @callback addEdge!(Spiro.Edge.t, Spiro.Vertex.t, Spiro.Vertex.t) :: Spiro.Edge.t
  # @callback edges(list()) :: list()
  # @callback vertices(list()) :: list()
  # @callback execute(Spiro.Traversal.t) :: tuple()
  # @callback execute!(Spiro.Traversal.t) :: list()


end
