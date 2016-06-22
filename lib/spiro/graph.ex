defmodule Spiro.Graph do
  @moduledoc """
  Provides operations specific to graphs.
  """

  alias Spiro.Traversal

  @doc "Add a vertex to the graph."
  def addVertex(vertex) do
    #TODO
  end

  @doc "Add a vertex to the graph, return vertex instead of tuple."
  def addVertex!(vertex) do
    #TODO
  end

  @doc "Add an edge to the graph."
  def addEdge(edge) do
    #TODO
  end

  @doc "Add an edge to the graph, return edge instead of tuple."
  def addEdge!(vertex) do
    #TODO
  end

  @doc "Retrieve a list of edges.  If list of IDs not provided, return all."
  def edges(edge_ids \\ :empty) do
    #TODO
  end

  @doc "Retrieve a list of vertices.  If list of IDs not provided, return all."
  def vertices(vertex_ids \\ :empty) do
    #TODO
  end

  @doc "Return an initialized traverser for use in a query pipeline."
  def traversal() do
    #TODO
    Traversal.new()
  end

  @doc "Return the list of implemented TinkerPop3 features, if applicable"
  def features() do
    #TODO
    %{
      "DataTypeFeatures": %{},
      "EdgeFeatures": %{},
      "EdgePropertyFeatures": %{},
      "ElementFeatures": %{},
      "GraphFeatures": %{},
      "PropertyFeatures": %{},
      "VariableFeatures": %{},
      "VertexFeatures": %{},
      "VertexPropertyFeatures": %{},
    }
  end
end
