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

      if Spiro.Adapter.supports_function?(@adapter, :vertex_labels) do
        def update(element) do
          case element.labels do
            [] -> element |> set_properties
            _  -> element |> set_properties |> set_labels
          end
        end
        def update(element, properties, labels \\ []) do
          case labels do
            [] -> element |> set_properties(properties)
            _  -> element |> set_properties(properties) |> set_labels(labels)
          end
        end
      else
        def update(element), do: set_properties(element)
        def update(element, properties), do: set_properties(element, properties)
      end

      def set_properties(%{} = element, properties) when is_list(properties) do
        set_properties(%{element | properties: properties})
      end
      def set_properties(%Vertex{} = vertex) do
        @adapter.set_vertex_properties(vertex, __MODULE__)
      end
      def set_properties(%Edge{} = edge) do
        @adapter.set_edge_properties(edge, __MODULE__)
      end

      def add_properties(%Vertex{} = vertex, properties) when is_list(properties) do
        @adapter.add_vertex_properties(vertex, properties, __MODULE__)
      end
      def add_properties(%Edge{} = edge, properties) when is_list(properties) do
        @adapter.add_edge_properties(edge, properties, __MODULE__)
      end

      def delete(%Vertex{} = vertex) do
        @adapter.delete_vertex(vertex, __MODULE__)
      end
      def delete(%Edge{} = edge) do
        @adapter.delete_edge(edge, __MODULE__)
      end

      def vertices(vertices_id \\ []) do
        @adapter.vertices(vertices_id, __MODULE__)
      end # TODO: not in neo4j adapter

      def edges(edges_id \\ []) do
        @adapter.edges(edges_id, __MODULE__)
      end # TODO: not in neo4j adapter

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
      end
      def get_property(%Edge{} = edge, key) do
        @adapter.get_edge_property(edge, key, __MODULE__)
      end

      def set_property(%Vertex{} = vertex, key, value) do
        @adapter.set_vertex_property(vertex, key, value, __MODULE__)
      end
      def set_property(%Edge{} = edge, key, value) do
        @adapter.set_edge_property(edge, key, value, __MODULE__)
      end

      def fetch_properties(element) do
          Map.put(element, :properties, properties(element))
      end

      # def edge_endpoints(%Edge{} = edge) do
      #   @adapter.edge_endpoints(edge, __MODULE__)
      # end # not in neo4j adapter
      # def fetch_endpoints(%Edge{} = edge) do
      #   with {from, to} = edge_endpoints(edge), do: edge |> Map.put(:from, from) |> Map.put(:to, to)
      # end # not in neo4j adapter
      
      def vertex_degree(%Vertex{} = vertex, direction, types \\ []) do
        @adapter.vertex_degree(vertex, direction, types, __MODULE__)
      end

      def adjacent_edges(%Vertex{} = vertex, direction, types \\ []) do
        @adapter.adjacent_edges(vertex, direction, types, __MODULE__)
      end

      def vertex_neighbours(%Vertex{} = vertex, direction, types \\ []) do
        @adapter.vertex_neighbours(vertex, direction, types, __MODULE__)
      end

      if Spiro.Adapter.supports_function?(@adapter, :edge_type) do
        def list_types() do
          @adapter.list_types(__MODULE__)
        end
      end

      if Spiro.Adapter.supports_function?(@adapter, :vertex_labels) do
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
        def set_labels(vertex, labels) when is_list(labels) do
          set_labels(%{vertex | labels: labels})
        end
        def set_labels(vertex) do
          @adapter.set_labels(vertex, __MODULE__)
        end
        def remove_label(vertex, label) do
          @adapter.remove_label(vertex, label, __MODULE__)
        end
      end

      def supports_function?(function) do
        Spiro.Adapter.supports_function?(@adapter, function)
      end

    end
  end
  
  @doc false
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

  @doc """
  Adds a vertex to the graph. Returns vertex or raises an exception in case of error.
  The argument can be a keyword list of properties, or a `%Vertex{}` struct.
  """
  @callback add_vertex(properties :: keyword) :: Spiro.Vertex.t
  @callback add_vertex(vertex :: Spiro.Vertex.t) :: Spiro.Vertex.t
  # TODO: should be with !

  # @doc "Add an edge to the graph."
  # @callback add_edge(keyword, Spiro.Vertex.t, Spiro.Vertex.t, String.t) :: ok_tuple(Spiro.Edge.t)
  # @callback add_edge(keyword, Spiro.Vertex.t, Spiro.Vertex.t) :: ok_tuple(Spiro.Edge.t)
  # @callback add_edge(Spiro.Edge.t, Spiro.Vertex.t, Spiro.Vertex.t) :: ok_tuple(Spiro.Edge.t)
  # TODO: ^

  @doc """
  Adds an edge to the graph. Returns vertex or raises an exception in case of error.
  `type` is optional.
  """
  @callback add_edge(properties :: keyword, vertex_from :: Spiro.Vertex.t, vertex_to :: Spiro.Vertex.t, type :: String.t) :: Spiro.Edge.t
  @callback add_edge(edge :: Spiro.Edge.t, vertex_from :: Spiro.Vertex.t, vertex_to :: Spiro.Vertex.t, type :: String.t) :: Spiro.Edge.t
  @doc """
  Adds an edge to the graph. Returns vertex or raises an exception in case of error.
  Expects the `%Edge{}` struct passed in parameter to include adjacent vertices (in `:from` and `:to` fields).

  """
  @callback add_edge(edge :: Spiro.Edge.t) :: Spiro.Edge.t
  # TODO: should be with !

  @doc """
  Updates properties of the given element, and labels if applicable. Expects data to be included in the given struct.
  """
  @callback update(element :: element) :: element

  @doc """
  Updates properties of the given element.
  """
  @callback update(element :: element, properties :: keyword) :: element

  @doc """
  Updates properties and labels of the given element.
  """
  @callback update(element :: element, properties :: keyword, labels :: list(String.t)) :: element

  @doc "Sets properties from a vertex or an edge."
  @callback set_properties(element :: element, properties :: keyword) :: element

  @doc "Sets properties from a vertex or an edge. Expects properties to be included in the given struct."
  @callback set_properties(element :: element) :: element

  @doc "Adds properties to the given vertex or edge."
  @callback add_properties(element :: element, properties :: keyword) :: element

  @doc "Deletes a vertex or an edge."
  @callback delete(element :: element) :: true

  @doc "Gets properties from a vertex or an edge. Returns the properties."
  @callback properties(element :: element) :: keyword

  @doc "Gets a single property from a vertex or an edge."
  @callback get_property(element :: element, key :: String.t) :: term

  @doc "Sets a property from a vertex or an edge."
  @callback set_property(element :: element, key :: atom, value :: term) :: element

  @doc "Gets properties from a vertex or an edge. Returns the element with its properties fetched."
  @callback fetch_properties(element :: element) :: element

  @doc """
  Gets the degree of the given vertex. Expects a direction (`:in` for emanating edges, `:out` for incident edges, `:all` for both), and an optional list of edge types.
  """
  @callback vertex_degree(vertex :: Spiro.Vertex.t, direction :: (:in | :out | :all), types :: list(String.t)) :: pos_integer

  @doc """
  Gets a list of adjacent edges of the given vertex. Expects a direction (`:in` for emanating edges, `:out` for incident edges, `:all` for both), and an optional list of edge types.
  """
  @callback adjacent_edges(vertex :: Spiro.Vertex.t, direction :: (:in | :out | :all), types :: list(String.t)) :: list(Spiro.Edge.t)

  @doc """
  Gets the list of neighbour vertices of the given vertex. Expects a direction (`:in` for emanating edges, `:out` for incident edges, `:all` for both), and an optional list of edge types.
  """
  @callback vertex_neighbours(vertex :: Spiro.Vertex.t, direction :: (:in | :out | :all), types :: list(String.t)) :: list(Spiro.Vertex.t)

  @doc "Lists all labels of vertices in the graph."
  @callback list_labels() :: list(String.t)

  @doc "Lists all types of edges in the graph."
  @callback list_types() :: list(String.t)

  @doc "Gets a list a vertices having the given label."
  @callback vertices_by_label(label :: String.t) :: list(Spiro.Vertex.t)

  @doc "Gets the labels of the given vertex."
  @callback get_labels(vertex :: Spiro.Vertex.t) :: list(String.t)

  @doc "Adds a list of labels to the given vertex."
  @callback add_labels(vertex :: Spiro.Vertex.t, labels :: list(String.t)) :: Spiro.Vertex.t

  @doc "Resets the labels of the given vertex."
  @callback set_labels(vertex :: Spiro.Vertex.t, labels :: list(String.t)) :: Spiro.Vertex.t

  @doc "Resets the labels of the given vertex. Expects the labels to be included in the `%Vertex` struct."
  @callback set_labels(vertex :: Spiro.Vertex.t) :: Spiro.Vertex.t

  @doc "Removes a label from the given vertex."
  @callback remove_label(vertex :: Spiro.Vertex.t, label :: String.t) :: none

  @doc "Retrieves a list of vertices.  If list of IDs not provided, returns all."
  @callback vertices(list(pos_integer)) :: list(Spiro.Vertex.Vertex)

  @doc "Retrieves a list of edges.  If list of IDs not provided, returns all."
  @callback edges(list(pos_integer)) :: list(Spiro.Edge.t)

  @doc "Returns an initialized traverser for use in a query pipeline."
  @callback traversal() :: Spiro.Traversal.t

  @callback execute(traversal :: Spiro.Traversal.t) :: tuple
  @callback execute!(traversal :: Spiro.Traversal.t) :: list

  @callback supports_function?(function :: atom) :: boolean

  @optional_callbacks list_labels: 0,
                      list_types: 0,
                      vertices_by_label: 1,
                      get_labels: 1,
                      add_labels: 2,
                      set_labels: 2,
                      set_labels: 1,
                      remove_label: 2,
                      update: 3

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
