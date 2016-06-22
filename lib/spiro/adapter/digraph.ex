defmodule Spiro.Adapter.Digraph do
  @moduledoc """
  Implement graph operations for an Erlang Digraph.
  """

  @behaviour Spiro.Adapter

  def addEdge(edge, v_from, v_to), do: {:ok, edge}
  def addEdge!(edge, v_from, v_to), do: edge
  def addVertex(vertex), do: {:ok, vertex}
  def addVertex!(vertex), do: vertex
  def edges(ids \\ []), do: []
  def vertices(ids \\ []), do: []
  def execute(trav), do: []

end
