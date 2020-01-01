defmodule DataMerge.Hotels.Normaliser.Third do
  @moduledoc """
  Normaliser for data from https://api.myjson.com/bins/j6kzm
  """
  @behaviour DataMerge.Hotels.Normaliser

  alias DataMerge.Hotels
  alias DataMerge.Hotels.Hotel
  alias DataMerge.Hotels.Hotel.Image
  alias DataMerge.Hotels.Hotel.Location
  alias DataMerge.Utils

  require Logger

  @subs %{"tub" => "bath tub"}

  @impl DataMerge.Hotels.Normaliser
  @spec normalise(map) :: DataMerge.Hotels.Hotel.t()
  def normalise(%{} = map) do
    {exact, near, unmatched} =
      map
      |> (&(Map.get(&1, "amenities", []) || [])).()
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

    %Hotel{
      id: map["id"],
      destination_id: map["destination"],
      name: map["name"],
      location: %Location{
        lat: map["lat"],
        lng: map["lng"],
        address: Utils.fmap(map["address"], &String.trim/1),
        city: nil,
        country: nil
      },
      description: Utils.fmap(map["info"], &String.trim/1),
      amenities: exact ++ near,
      images:
        map
        |> (&(Map.get(&1, "images", %{}) || %{})).()
        |> Map.to_list()
        |> Enum.flat_map(fn {k, v} ->
          Enum.map(v, &%Image{type: k, link: &1["url"], description: &1["description"]})
        end),
      booking_conditions: []
    }
  end
end
