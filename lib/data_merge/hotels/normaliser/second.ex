defmodule DataMerge.Hotels.Normaliser.Second do
  @moduledoc """
  Normaliser for data from https://api.myjson.com/bins/1fva3m
  """
  @behaviour DataMerge.Hotels.Normaliser

  alias DataMerge.Hotels
  alias DataMerge.Hotels.Hotel
  alias DataMerge.Hotels.Hotel.Image
  alias DataMerge.Hotels.Hotel.Location
  alias DataMerge.Utils

  require Logger

  @impl DataMerge.Hotels.Normaliser
  def normalise(%{} = map) do
    {exact, near, unmatched} =
      map
      |> (&(Map.get(&1, "amenities", %{}) || %{})).()
      |> Map.to_list()
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

    %Hotel{
      id: map["hotel_id"],
      destination_id: map["destination_id"],
      name: map["hotel_name"],
      location: %Location{
        lat: nil,
        lng: nil,
        address: Utils.fmap(map["location"]["address"], &String.trim/1),
        city: nil,
        country: map["location"]["country"]
      },
      description: Utils.fmap(map["details"], &String.trim/1),
      amenities: exact ++ near,
      images:
        map
        |> (&(Map.get(&1, "images", %{}) || %{})).()
        |> Map.to_list()
        |> Enum.flat_map(fn {k, v} ->
          Enum.map(v, &%Image{type: k, link: &1["link"], description: &1["caption"]})
        end),
      booking_conditions: Map.get(map, "booking_conditions", []) || []
    }
  end
end
