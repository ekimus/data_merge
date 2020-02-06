defmodule DataMerge.Hotels.Normaliser.Second do
  @moduledoc """
  Normaliser for data from https://api.myjson.com/bins/1fva3m
  """
  @behaviour DataMerge.Hotels.Normaliser

  alias DataMerge.Hotels
  alias DataMerge.Utils

  require Logger

  @impl DataMerge.Hotels.Normaliser
  @spec normalise(map :: Map.t()) :: DataMerge.Hotels.Hotel.t()
  def normalise(map) do
    {exact, near, unmatched} =
      map
      |> (&(Map.get(&1, "amenities", %{}) || %{})).()
      |> Enum.flat_map(fn {_, v} -> Enum.map(v, &Utils.normalise/1) end)
      |> Hotels.amenities()

    case unmatched do
      [] ->
        :ok

      xs ->
        xs
        |> inspect()
        |> (&Logger.warn(to_string(__MODULE__) <> " unmatched amenities: " <> &1)).()
    end

    %{
      id: map["hotel_id"],
      destination_id: map["destination_id"],
      name: map["hotel_name"],
      lat: nil,
      lng: nil,
      address: Utils.fmap(map["location"]["address"], &String.trim/1),
      city: nil,
      country: map["location"]["country"],
      description: Utils.fmap(map["details"], &String.trim/1),
      amenities: exact ++ near,
      images:
        map
        |> (&(Map.get(&1, "images", %{}) || %{})).()
        |> Enum.flat_map(fn {k, v} ->
          Enum.map(v, &%{type: k, link: &1["link"], description: &1["caption"]})
        end),
      booking_conditions:
        (Map.get(map, "booking_conditions", []) || [])
        |> Enum.map(&%{booking_condition: &1})
    }
  end
end
