defmodule Spiro.Graph do
  @moduledoc """
  Provides operations specific to graphs.
  """

  alias Spiro.Vertex
  alias Spiro.Edge

  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do
      {otp_app, adapter, config, adapter_opts} = Spiro.Graph.parse_config(__MODULE__, opts)
      @otp_app otp_app
      @adapter adapter
      @config config
      @adapter_opts adapter_opts

      def traversal(), do: @adapter.traversal()

      def start_link(), do: @adapter.start_link(@adapter_opts, __MODULE__)

      def add_vertex(properties) when is_list(properties), do: @adapter.add_vertex(%Vertex{properties: properties}, __MODULE__)
      def add_vertex(%Vertex{} = v), do: @adapter.add_vertex(v, __MODULE__)

      def add_edge(properties, v1, v2) when is_list(properties), do: @adapter.add_edge(%Edge{properties: properties}, v1, v2, __MODULE__)
      def add_edge(%Edge{} = e, v1, v2), do: @adapter.add_edge(e, v1, v2, __MODULE__)

      def update_vertex(%Vertex{} = vertex, properties) when is_list(properties), do: @adapter.update_vertex(%{vertex | properties: properties}, __MODULE__)
      def update_vertex(%Vertex{} = vertex, fun) when is_function(fun), do: @adapter.update_vertex(vertex, fun, __MODULE__)
      def update_vertex(%Vertex{} = vertex), do: @adapter.update_vertex(vertex, __MODULE__)

      def update_edge(%Vertex{} = edge, properties) when is_list(properties), do: @adapter.update_edge(%{edge | properties: properties}, __MODULE__)
      def update_edge(%Vertex{} = edge, fun) when is_function(fun), do: @adapter.update_edge(edge, fun, __MODULE__)
      def update_edge(%Vertex{} = edge), do: @adapter.update_edge(edge, __MODULE__)

      def delete_vertex(%Vertex{} = vertex), do: @adapter.delete_vertex(vertex, __MODULE__)
      def delete_edge(%Edge{} = edge), do: @adapter.delete_edge(edge, __MODULE__)

      def vertices(), do: @adapter.vertices(__MODULE__)
      def edges(), do: @adapter.edges(__MODULE__)

      def properties(list) when is_list(list), do: Enum.map(list, &properties(&1))
      def properties(%Vertex{} = vertex), do: @adapter.vertex_properties(vertex, __MODULE__)
      def properties(%Edge{} = edge), do: @adapter.edge_properties(edge, __MODULE__)

      def edge_endpoints(%Edge{} = edge), do: @adapter.edge_endpoints(edge, __MODULE__)

      def add_properties(element), do: Map.put(element, :properties, properties(element))
      def add_endpoints(%Edge{} = edge) do
        with {from, to} = edge_endpoints(edge), do: edge |> Map.put(:from, from) |> Map.put(:to, to)
      end
      
      def in_degree(%Vertex{} = vertex), do: @adapter.in_degree(vertex, __MODULE__)
      def out_degree(%Vertex{} = vertex), do: @adapter.out_degree(vertex, __MODULE__)
      def in_edges(%Vertex{} = vertex), do: @adapter.in_edges(vertex, __MODULE__)
      def out_edges(%Vertex{} = vertex), do: @adapter.out_edges(vertex, __MODULE__)
      def in_neighbours(%Vertex{} = vertex), do: @adapter.in_neighbour(vertex, __MODULE__)
      def out_neighbours(%Vertex{} = vertex), do: @adapter.out_neighbour(vertex, __MODULE__)


    end
  end
  
  def parse_config(graph, opts) do
    otp_app = Keyword.fetch!(opts, :otp_app)
    config  = Application.get_env(otp_app, graph, [])
    adapter = opts[:adapter] || config[:adapter]
    type = opts[:type] || config[:type]
    adapter_opts = opts[:adapter_opts] || config[:adapter_opts]

    unless adapter do
      raise ArgumentError, "missing :adapter configuration in " <>
      "config #{inspect otp_app}, #{inspect graph}"
    end

    unless Code.ensure_loaded?(adapter) do
      raise ArgumentError, "adapter #{inspect adapter} was not compiled, " <>
      "ensure it is correct and it is included as a project dependency"
    end
    {otp_app, adapter, type, adapter_opts}
  end
end
