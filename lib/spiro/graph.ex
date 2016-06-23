defmodule Spiro.Graph do
  @moduledoc """
  Provides operations specific to graphs.
  """

  alias Spiro.Vertex
  alias Spiro.Edge

  defmacro __using__(opts) do
    quote do
      {config, adapter, adapter_opts} = Spiro.Graph.parse_config(__MODULE__, unquote(opts))
      @adapter adapter
      @config config
      @adapter_opts adapter_opts

      def traversal(), do: @adapter.traversal()

      def start_link() do
        opts = {@adapter, @adapter_opts, __MODULE__}
        Spiro.Graph.Supervisor.start_link(opts)
      end

      def add_vertex(properties) when is_list(properties) do
        @adapter.add_vertex(%Vertex{properties: properties}, __MODULE__)
      end
      def add_vertex(%Vertex{} = v) do
        @adapter.add_vertex(v, __MODULE__)
      end

      def add_edge(properties, v1, v2, type) when is_list(properties) do
        @adapter.add_edge(%Edge{properties: properties, from: v1, to: v2, type: type}, __MODULE__)
      end
      def add_edge(properties, v1, v2) when is_list(properties) do
        @adapter.add_edge(%Edge{properties: properties, from: v1, to: v2}, __MODULE__)
      end
      def add_edge(%Edge{} = edge, v1, v2) do
        @adapter.add_edge(%{edge | from: v1, to: v2}, v1, v2, __MODULE__)
      end

      def update_vertex(%Vertex{} = vertex, properties) when is_list(properties) do
        @adapter.update_vertex(%{vertex | properties: properties}, __MODULE__)
      end
      # def update_vertex(%Vertex{} = vertex, fun) when is_function(fun) do
      #   @adapter.update_vertex(vertex, fun, __MODULE__)
      # end # not in neo4j adapter
      def update_vertex(%Vertex{} = vertex) do
        @adapter.update_vertex(vertex, __MODULE__)
      end

      def update_edge(%Vertex{} = edge, properties) when is_list(properties) do
        @adapter.update_edge(%{edge | properties: properties}, __MODULE__)
      end
      # def update_edge(%Vertex{} = edge, fun) when is_function(fun) do
      #   @adapter.update_edge(edge, fun, __MODULE__)
      # end # not in neo4j adapter
      def update_edge(%Vertex{} = edge) do
        @adapter.update_edge(edge, __MODULE__)
      end

      def delete_vertex(%Vertex{} = vertex) do
        @adapter.delete_vertex(vertex, __MODULE__)
      end
      def delete_edge(%Edge{} = edge) do
        @adapter.delete_edge(edge, __MODULE__)
      end

      # def vertices() do
      #   @adapter.vertices(__MODULE__)
      # end # not in neo4j adapter
      # def edges() do
      #   @adapter.edges(__MODULE__)
      # end # not in neo4j adapter

      def properties(list) when is_list(list) do
          Enum.map(list, &properties(&1))
      end
      def properties(%Vertex{} = vertex) do
        @adapter.vertex_properties(vertex, __MODULE__)
      end
      def properties(%Edge{} = edge) do
        @adapter.edge_properties(edge, __MODULE__)
      end

      def get_property(%Vertex{} = vertex) do
        @adapter.get_vertex_property(vertex, key, __MODULE__)
      end # not in digraph adapter
      def get_property(%Edge{} = edge) do
        @adapter.get_edge_property(edge, key, __MODULE__)
      end # not in digraph adapter

      def set_property(%Vertex{} = vertex) do
        @adapter.set_vertex_property(vertex, key, __MODULE__)
      end # not in digraph adapter
      def set_property(%Edge{} = edge) do
        @adapter.set_edge_property(edge, key, __MODULE__)
      end # not in digraph adapter

      def fetch_properties(element) do
          Map.put(element, :properties, properties(element))
      end

      # def edge_endpoints(%Edge{} = edge) do
      #   @adapter.edge_endpoints(edge, __MODULE__)
      # end # not in neo4j adapter
      # def fetch_endpoints(%Edge{} = edge) do
      #   with {from, to} = edge_endpoints(edge), do: edge |> Map.put(:from, from) |> Map.put(:to, to)
      # end # not in neo4j adapter
      
      # TODO: these 3 functions (and the 3 next) can be merged into one (with param :in|:out|:all)
      # TODO: these functions should accept a list of labels for neo4j
      #       but not for digraph
      def all_degree(%Vertex{} = vertex) do
        @adapter.all_degree(vertex, __MODULE__)
      end
      def in_degree(%Vertex{} = vertex) do
        @adapter.in_degree(vertex, __MODULE__)
      end
      def out_degree(%Vertex{} = vertex) do
        @adapter.out_degree(vertex, __MODULE__)
      end

      def all_edges(%Vertex{} = vertex) do
        @adapter.all_edges(vertex, __MODULE__)
      end
      def in_edges(%Vertex{} = vertex) do
        @adapter.in_edges(vertex, __MODULE__)
      end
      def out_edges(%Vertex{} = vertex) do
        @adapter.out_edges(vertex, __MODULE__)
      end
      # def in_neighbours(%Vertex{} = vertex) do
      #   @adapter.in_neighbour(vertex, __MODULE__)
      # end # not in neo4j adapter
      # def out_neighbours(%Vertex{} = vertex) do
      #   @adapter.out_neighbour(vertex, __MODULE__)
      # end # not in neo4j adapter

      if true do # check if types are supported
        def list_types() do
          @adapter.list_types(__MODULE__)
        end
      end

      if true do # check if labels are supported
        def list_labels() do
          @adapter.list_labels(__MODULE__)
        end

        def vertices_by_label(label) do
          @adapter.vertices_by_label(label, __MODULE__)
        end
        def get_labels(vertex) do
          @adapter.get_labels(vertex, __MODULE__)
        end
        def add_labels(vertex, labels) do
          @adapter.add_labels(vertex, labels, __MODULE__)
        end
        def set_labels(vertex) do
          @adapter.set_labels(vertex, __MODULE__)
        end
        def remove_label(vertex, label) do
          @adapter.remove_label(vertex, label, __MODULE__)
        end
      end

    end
  end
  
  def parse_config(graph, opts) do
    config  = case Keyword.fetch(opts, :otp_app) do
      {:ok, otp_app} ->
        Application.get_env(otp_app, graph, [])
      :error -> opts
    end
    adapter = config[:adapter]
    adapter_opts = config[:adapter_opts]

    unless adapter do
      raise ArgumentError, "missing :adapter configuration in " <>
      "config :your_otp_app, #{inspect graph}" <>
      "or \"use Spiro.Graph\" parameters"
    end

    unless Code.ensure_loaded?(adapter) do
      raise ArgumentError, "adapter #{inspect adapter} was not compiled, " <>
      "ensure it is correct and it is included as a project dependency"
    end
    {config, adapter, adapter_opts}
  end
end
