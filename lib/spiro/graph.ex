defmodule Spiro.Graph do
  @moduledoc """
  Provides operations specific to graphs.
  """

  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do
      {otp_app, adapter, type} = Spiro.Graph.parse_config(__MODULE__, opts)
      @otp_app otp_app
      @adapter adapter
      @type type
    end
  end
  
  def parse_config(graph, opts) do
    otp_app = Keyword.fetch!(opts, :otp_app)
    config  = Application.get_env(otp_app, graph, [])
    adapter = opts[:adapter] || config[:adapter]
    type = opts[:type] || config[:type]

    unless adapter do
      raise ArgumentError, "missing :adapter configuration in " <>
      "config #{inspect otp_app}, #{inspect repo}"
    end

    unless Code.ensure_loaded?(adapter) do
      raise ArgumentError, "adapter #{inspect adapter} was not compiled, " <>
      "ensure it is correct and it is included as a project dependency"
    end
    {otp_app, adapter, type}
  end
end
