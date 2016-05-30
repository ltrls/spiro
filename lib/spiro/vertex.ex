defmodule Spiro.Vertex do
  @moduledoc """
  Provides operations specific to vertex elements.

  See more generic operations in **Spiro.Element**.
  """

  defmacro __using__ do
    quote do
      import unquote(__MODULE__)
    end
  end
end
