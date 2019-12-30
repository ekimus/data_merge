defmodule DataMerge.Client do
  @moduledoc """
  Resource supplier client.
  """
  import DataMerge.Utils

  def reducer(%{} = a, %{} = b), do: Map.merge(a, b, &merger/3)

  defp merger(:amenities, a, b) do
    (a ++ b)
    |> Enum.group_by(& &1.type, & &1.amenity)
    |> Map.to_list()
    |> Enum.flat_map(fn {k, v} ->
      v
      |> Enum.sort()
      |> Enum.uniq()
      |> Enum.map(&%{type: k, amenity: &1})
    end)
  end

  defp merger(:images, a, b) do
    (a ++ b)
    |> Enum.group_by(& &1.type, &%{link: &1.link, description: &1.description})
    |> Map.to_list()
    |> Enum.flat_map(fn {k, v} ->
      v
      |> Enum.sort()
      |> Enum.uniq()
      |> Enum.map(&%{type: k, link: &1.link, description: &1.description})
    end)
  end

  defp merger(:booking_conditions, a, b), do: (a ++ b) |> Enum.sort() |> Enum.uniq()
  defp merger(:location, a, b), do: Map.merge(a, b, &merger/3)
  defp merger(_, nil, b), do: b
  defp merger(_, a, nil), do: a
  defp merger(_, _, b), do: b
end
