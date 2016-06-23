defmodule Spiro.Vertex do
  @moduledoc """
  Provides operations specific to vertex elements.

  See more generic operations in **Spiro.Element**.
  """

  defstruct [id: nil, properties: [], labels: []]
  @type t :: %Spiro.Vertex{id: pos_integer | nil,
                               properties: keyword | [],
                               labels: [String.t] | []}

end
