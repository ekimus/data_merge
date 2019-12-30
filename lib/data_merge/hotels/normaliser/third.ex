defmodule DataMerge.Hotels.Normaliser.Third do
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
      id: map["id"],
      destination_id: map["destination"],
      name: map["name"],
      location: %Location{
        lat: map["lat"],
        lng: map["lng"],
        address: fmap(map["address"], &String.trim/1),
        city: nil,
        country: nil
      },
      description: fmap(map["info"], &String.trim/1),
      amenities:
        map
        |> Map.get("amenities", [])
        |> Enum.map(&%Amenity{type: "room", amenity: &1 |> String.trim() |> String.downcase()}),
      images:
        map
        |> Map.get("images", %{})
        |> Map.to_list()
        |> Enum.flat_map(fn {k, v} ->
          Enum.map(v, &%Image{type: k, link: &1["url"], description: &1["description"]})
        end),
      booking_conditions: []
    }
  end
end
