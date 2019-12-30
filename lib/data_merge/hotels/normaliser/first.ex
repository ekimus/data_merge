defmodule DataMerge.Hotels.Normaliser.First do
  @moduledoc """
  Normaliser for data from https://api.myjson.com/bins/gdmqa
  """
  import DataMerge.Utils
  alias DataMerge.Hotels.Hotel
  alias DataMerge.Hotels.Hotel.Amenity
  alias DataMerge.Hotels.Hotel.Location
  @behaviour DataMerge.Hotels.Normaliser

  @impl DataMerge.Hotels.Normaliser
  @spec normalise(map) :: DataMerge.Hotels.Hotel.t()
  def normalise(map) do
    %Hotel{
      id: map["Id"],
      destination_id: map["DestinationId"],
      name: map["Name"],
      location: %Location{
        lat: map["Latitude"],
        lng: map["Longitude"],
        address:
          [map["Address"], map["PostalCode"]]
          |> Enum.reject(&is_nil/1)
          |> Enum.map(&String.trim/1)
          |> Enum.join(", ")
          |> (&if(&1 == "", do: nil, else: &1)).(),
        city: map["City"],
        country: map["Country"]
      },
      description: fmap(map["Description"], &String.trim/1),
      amenities:
        map
        |> (&(Map.get(&1, "Facilities", []) || [])).()
        |> Enum.map(&%Amenity{type: "general", amenity: &1 |> String.trim() |> String.downcase()}),
      images: [],
      booking_conditions: []
    }
  end
end
