defmodule DataMerge.Utils do
  @moduledoc """
  Utility functions
  """
  def fmap(nil, _), do: nil
  def fmap(x, f), do: apply(f, [x])

  def normalise(s), do: s |> String.trim() |> String.downcase()

  def substitutions(xs, map) do
    xs
    |> Enum.reduce([], &[Map.get(map, &1) || &1 | &2])
    |> Enum.reverse()
  end
end
