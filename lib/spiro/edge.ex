defmodule Spiro.Edge do
  @moduledoc """
  Provides operations specific to edge elements.

  See more generic operations in **Spiro.Element**.
  """

  defmacro __using__ do
    quote do
      import unquote(__MODULE__)
    end
  end
end
