defmodule DataMerge.Utils do
  @moduledoc """
  Utility functions
  """
  def fmap(nil, _), do: nil
  def fmap(x, f), do: apply(f, [x])
end
