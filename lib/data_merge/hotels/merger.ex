defmodule DataMerge.Hotels.Merger do
  @moduledoc """
  Merger merges resources
  """
  alias DataMerge.Hotels.Hotel
  alias DataMerge.Hotels.Resource
  require Logger

  def merge(resources) do
    resources
    |> Task.async_stream(Resource, :get, [], ordered: false)
    |> Stream.each(fn
      {:error, reason} -> reason |> inspect() |> Logger.warn()
      {:ok, result} -> result |> inspect() |> Logger.debug()
    end)
    |> Stream.flat_map(fn {:ok, {:ok, result}} -> result end)
    |> Enum.group_by(& &1.id, & &1)
    |> Map.to_list()
    |> Enum.map(fn {_k, v} -> Enum.reduce(v, &Hotel.reducer/2) end)
  end
end
