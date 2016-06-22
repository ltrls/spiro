defmodule Spiro.Adapter do
  @moduledoc """
  Provides base for graph system adapters.
  """
  # http://tinkerpop.apache.org/javadocs/3.0.2-incubating/core/index.html?org/apache/tinkerpop/gremlin/process/traversal/dsl/graph/GraphTraversal.html
  @callback addEdge(Spiro.Edge.t, Spiro.Vertex.t, Spiro.Vertex.t) :: tuple()
  @callback addEdge!(Spiro.Edge.t, Spiro.Vertex.t, Spiro.Vertex.t) :: Spiro.Edge.t
  @callback addVertex(Spiro.Vertex.t) :: tuple()
  @callback addVertex!(Spiro.Vertex.t) :: Spiro.Vertex.t
  @callback edges(list()) :: list()
  @callback vertices(list()) :: list()
  @callback execute(Spiro.Traversal.t) :: tuple()
  @callback execute!(Spiro.Traversal.t) :: list()

  def supported_functions(), do: %{}

  def supports_function?(function) do
    case supported_functions() do
      %{^function => :true} -> :true
      _ -> :false
    end
  end

  defoverridable [supported_functions: 0]
end
