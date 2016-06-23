defmodule Spiro.Edge do
  @moduledoc """
  Provides operations specific to edge elements.

  See more generic operations in **Spiro.Element**.
  """

  defstruct [id: nil, from: nil, to: nil, properties: [], type: nil]
  @type t :: %Spiro.Edge{id: pos_integer | nil,
                         from: Vertex.t | nil,
                         to: Vertex.t | nil,
                         properties: keyword | [],
                         type: String.t | nil}

end
