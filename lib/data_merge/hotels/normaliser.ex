defmodule DataMerge.Hotels.Normaliser do
  @moduledoc """
  Normaliser behaviour
  """
  @callback normalise(map) :: DataMerge.Hotels.Hotel.t()
end
