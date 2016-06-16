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
      def addVertex(v), do: @adapter.addV(v, __MODULE__)

      def new(), do: @adapter.new(@adapter_opts, __MODULE__)
      def addVertex!(v), do: @adapter.addV(v, __MODULE__)
      def addEdge(v, e1, e2), do: @adapter.addE(v, e1, e2, __MODULE__)
      def addEdge!(v, e1, e2), do: @adapter.addE(v, e1, e2, __MODULE__)
      def vertices(), do: @adapter.vertices(__MODULE__)
      def edges(), do: @adapter.edges(__MODULE__)
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
