defmodule Spiro.Graph.Supervisor do
  use Supervisor

  def start_link({_, _, module} = opts) do
    Supervisor.start_link(__MODULE__, opts, [name: Module.concat(module, Supervisor)])
  end

  def init({adapter, adapter_opts, module}) do
    children = [
      supervisor(adapter, [adapter_opts, module])
    ]
    supervise(children, strategy: :one_for_one)
  end

end
