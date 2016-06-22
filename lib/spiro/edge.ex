defmodule Spiro.Edge do
  @moduledoc """
  Provides operations specific to edge elements.

  See more generic operations in **Spiro.Element**.
  """

  defstruct label: nil, properties: %{}
  use ExConstructor
end
