defmodule Spiro.Graph do
  @moduledoc """
  Provides operations specific to graphs.
  """
  use Behaviour

  alias Spiro.Vertex
  alias Spiro.Edge
  alias Spiro.Traversal

  defmacro __using__(opts) do
    quote do
      @behaviour Spiro.Graph

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
        add_vertex(%Vertex{properties: properties})
      end
      def add_vertex(%Vertex{} = vertex) do
        @adapter.add_vertex(vertex, __MODULE__)
      end

      def add_edge(param, v1, v2, type \\ nil)
      def add_edge(properties, v1, v2, type) when is_list(properties) do
        add_edge(%Edge{properties: properties, from: v1, to: v2, type: type})
      end
      def add_edge(%Edge{} = edge, v1, v2, type) do
        add_edge(%{edge | from: v1, to: v2, type: type})
      end
      def add_edge(%Edge{} = edge) do
        @adapter.add_edge(edge, __MODULE__)
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

      def vertices() do
        @adapter.vertices(__MODULE__)
      end # not in neo4j adapter
      def edges() do
        @adapter.edges(__MODULE__)
      end # not in neo4j adapter

      def properties(list) when is_list(list) do
          Enum.map(list, &properties(&1))
      end
      def properties(%Vertex{} = vertex) do
        @adapter.vertex_properties(vertex, __MODULE__)
      end
      def properties(%Edge{} = edge) do
        @adapter.edge_properties(edge, __MODULE__)
      end

      def get_property(%Vertex{} = vertex, key) do
        @adapter.get_vertex_property(vertex, key, __MODULE__)
      end # not in digraph adapter
      def get_property(%Edge{} = edge, key) do
        @adapter.get_edge_property(edge, key, __MODULE__)
      end # not in digraph adapter

      def set_property(%Vertex{} = vertex, key, value) do
        @adapter.set_vertex_property(vertex, key, value, __MODULE__)
      end # not in digraph adapter
      def set_property(%Edge{} = edge, key, value) do
        @adapter.set_edge_property(edge, key, value, __MODULE__)
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
      
      def node_degree(%Vertex{} = vertex, direction, types \\ []) do
        @adapter.node_degree(vertex, direction, types, __MODULE__)
      end

      def adjacent_edges(%Vertex{} = vertex, direction, types \\ []) do
        @adapter.adjacent_edges(vertex, direction, types, __MODULE__)
      end

      def node_neighbours(%Vertex{} = vertex, direction, types \\ []) do
        @adapter.node_neighbours(vertex, direction, types, __MODULE__)
      end

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

  @type ok_tuple(t) :: {:ok, t} | {:error, String.t}
  @type element :: Spiro.Vertex.t | Spiro.Edge.t

  # @doc "Add a vertex to the graph."
  # @callback add_vertex(keyword) :: ok_tuple(Spiro.Vertex.t)
  # @callback add_vertex(Spiro.Vertex.t) :: ok_tuple(Spiro.Vertex.t)
  # TODO: ^

  @doc "Add a vertex to the graph, return vertex instead of tuple."
  @callback add_vertex(properties :: keyword) :: Spiro.Vertex.t
  @callback add_vertex(vertex :: Spiro.Vertex.t) :: Spiro.Vertex.t
  # TODO: should be with !

  # @doc "Add an edge to the graph."
  # @callback add_edge(keyword, Spiro.Vertex.t, Spiro.Vertex.t, String.t) :: ok_tuple(Spiro.Edge.t)
  # @callback add_edge(keyword, Spiro.Vertex.t, Spiro.Vertex.t) :: ok_tuple(Spiro.Edge.t)
  # @callback add_edge(Spiro.Edge.t, Spiro.Vertex.t, Spiro.Vertex.t) :: ok_tuple(Spiro.Edge.t)
  # TODO: ^

  @doc "Add an edge to the graph, return edge instead of tuple."
  @callback add_edge(properties :: keyword, vertex_from :: Spiro.Vertex.t, vertex_to :: Spiro.Vertex.t, type :: String.t) :: Spiro.Edge.t
  @callback add_edge(properties :: keyword, vertex_from :: Spiro.Vertex.t, vertex_to :: Spiro.Vertex.t) :: Spiro.Edge.t
  @callback add_edge(edge :: Spiro.Edge.t) :: Spiro.Edge.t
  # TODO: should be with !

  @callback update_vertex(vertex :: Spiro.Vertex.t, properties :: keyword) :: Spiro.Vertex.t
  @callback update_vertex(vertex :: Spiro.Vertex.t) :: Spiro.Vertex.t

  @callback update_edge(edge :: Spiro.Edge.t, properties :: keyword) :: Spiro.Edge.t
  @callback update_edge(edge :: Spiro.Edge.t) :: Spiro.Edge.t

  @callback delete_vertex(vertex :: Spiro.Vertex.t) :: none

  @callback delete_edge(edge :: Spiro.Edge.t) :: none

  @callback properties(element :: element) :: keyword

  @callback get_property(element :: element, key :: String.t) :: term

  @callback set_property(element :: element, key :: String.t, value :: term) :: none

  @callback fetch_properties(element :: element) :: element

  @callback node_degree(vertex :: Spiro.Vertex.t, direction :: (:in | :out | :all), types :: list(String.t)) :: pos_integer
  @callback adjacent_edges(vertex :: Spiro.Vertex.t, direction :: (:in | :out | :all), types :: list(String.t)) :: list(Spiro.Edge.t)
  @callback node_neighbours(vertex :: Spiro.Vertex.t, direction :: (:in | :out | :all), types :: list(String.t)) :: list(Spiro.Vertex.t)

  @callback list_labels() :: list(String.t)
  @callback list_types() :: list(String.t)
  @callback vertices_by_label(label :: String.t) :: list(Spiro.Vertex.t)
  @callback get_labels(vertex :: Spiro.Vertex.t) :: list(String.t)
  @callback add_labels(vertex :: Spiro.Vertex.t, labels :: list(String.t)) :: Spiro.Vertex.t
  @callback set_labels(vertex :: Spiro.Vertex.t) :: Spiro.Vertex.t
  @callback remove_label(vertex :: Spiro.Vertex.t, label :: String.t) :: none

  @callback execute(traversal :: Spiro.Traversal.t) :: tuple
  @callback execute!(traversal :: Spiro.Traversal.t) :: list

  @doc "Retrieve a list of vertices.  If list of IDs not provided, return all."
  @callback vertices() :: list(Spiro.Vertex.Vertex)

  @doc "Retrieve a list of edges.  If list of IDs not provided, return all."
  @callback edges() :: list(Spiro.Edge.t)

  @doc "Return an initialized traverser for use in a query pipeline."
  @callback traversal() :: Spiro.Traversal.t

  @optional_callbacks list_labels: 0,
                      list_types: 0,
                      vertices_by_label: 1,
                      get_labels: 1,
                      add_labels: 2,
                      set_labels: 1,
                      remove_label: 2

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
