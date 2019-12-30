defmodule DataMerge.Hotels.Normaliser.Second do
  @moduledoc """
  Normaliser for data from https://api.myjson.com/bins/1fva3m
  """
  import DataMerge.Utils
  alias DataMerge.Hotels.Hotel
  alias DataMerge.Hotels.Hotel.Amenity
  alias DataMerge.Hotels.Hotel.Image
  alias DataMerge.Hotels.Hotel.Location
  @behaviour DataMerge.Hotels.Normaliser

  @impl DataMerge.Hotels.Normaliser
  @spec normalise(map) :: DataMerge.Hotels.Hotel.t()
  def normalise(%{} = map) do
    %Hotel{
      id: map["hotel_id"],
      destination_id: map["destination_id"],
      name: map["hotel_name"],
      location: %Location{
        lat: nil,
        lng: nil,
        address: fmap(map["location"]["address"], &String.trim/1),
        city: nil,
        country: map["location"]["country"]
      },
      description: fmap(map["details"], &String.trim/1),
      amenities:
        map
        |> Map.get("amenities", %{})
        |> Map.to_list()
        |> Enum.flat_map(fn {k, v} ->
          Enum.map(v, &%Amenity{type: k, amenity: &1 |> String.trim() |> String.downcase()})
        end),
      images:
        map
        |> Map.get("images", %{})
        |> Map.to_list()
        |> Enum.flat_map(fn {k, v} ->
          Enum.map(v, &%Image{type: k, link: &1["link"], description: &1["caption"]})
        end),
      booking_conditions: Map.get(map, "booking_conditions", [])
    }
  end
end
