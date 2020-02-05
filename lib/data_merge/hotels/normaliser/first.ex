defmodule DataMerge.Hotels.Normaliser.First do
  @moduledoc """
  Normaliser for data from https://api.myjson.com/bins/gdmqa
  """
  @behaviour DataMerge.Hotels.Normaliser

  alias DataMerge.Hotels
  alias DataMerge.Utils

  require Logger

  @subs %{"pool" => "outdoor pool"}

  @impl DataMerge.Hotels.Normaliser
  def normalise(map) do
    {exact, near, unmatched} =
      map
      |> (&(Map.get(&1, "Facilities", []) || [])).()
      |> Enum.map(&Utils.normalise/1)
      |> Utils.substitutions(@subs)
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
      id: map["Id"],
      destination_id: map["DestinationId"],
      name: map["Name"],
      lat: map["Latitude"],
      lng: map["Longitude"],
      address:
        [map["Address"], map["PostalCode"]]
        |> Enum.reject(&is_nil/1)
        |> Enum.map(&String.trim/1)
        |> Enum.join(", ")
        |> (&if(&1 == "", do: nil, else: &1)).(),
      city: map["City"],
      country: map["Country"],
      description: Utils.fmap(map["Description"], &String.trim/1),
      amenities: exact ++ near,
      images: [],
      booking_conditions: []
    }
  end
end
