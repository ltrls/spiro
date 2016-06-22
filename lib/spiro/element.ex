defmodule Spiro.Element do
  @moduledoc """
  Provides macros for constructing a graph element (vertex, edge).
  """

  @doc false
  defmacro __using__(_) do
    quote do
      import Spiro.Element

      @before_compile Spiro.Element

      Module.register_attribute(__MODULE__, :spiro_properties, accumulate: true)
    end
  end

#  @doc """
#  Register properties for this element type.
#  """
#  @defmacro properties(label, [do: block]) do
#    quote do
#      label = unquote(label)
#
#      unless is_binary(label) do
#        raise ArgumentError, "element label must be a string, got: #{inspect source}"
#      end
#
#      Module.register_attribute(__MODULE__, :changeset_properties, accumulate: true)
#      Module.register_attribute(__MODULE__, :struct_properties, accumulate: true)
#
#      try do
#        import Spiro.Element
#        unquote(block)
#      after
#        :ok
#      end
#
#      properties = @spiro_properties |> Enum.reverse
#
#      Module.eval_quoted __ENV__, [
#        Spiro.Element.__defstruct__(@struct_properties),
#        Spiro.Element.__changeset__(@changeset_properties),
#        Spiro.Element.__properties__(label, properties, primary_key_fields),
#        Spiro.Element.__types__(properties),
#
#    end
#  end

end
