defmodule DataMerge.Hotels.Normaliser do
  @moduledoc """
  Normaliser behaviour
  """
  @callback normalise(map :: Map.t()) :: DataMerge.Hotels.Hotel.t()
end
