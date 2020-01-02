defmodule DataMerge.Hotels.Merger do
  @moduledoc """
  Merger merges resources
  """
  alias DataMerge.Hotels
  alias DataMerge.Hotels.Hotel
  alias DataMerge.Hotels.Hotel.BookingCondition
  alias DataMerge.Hotels.Hotel.Image
  alias DataMerge.Hotels.Hotel.Location
  alias DataMerge.Hotels.Resource
  require Logger

  def merge(resources) do
    resources
    |> Task.async_stream(Resource, :get, [], ordered: false)
    |> Flow.from_enumerable(max_demand: 20)
    |> Flow.flat_map(fn
      {:ok, {:ok, result}} ->
        result |> inspect() |> Logger.debug()
        result

      {:ok, {:error, reason}} ->
        reason |> inspect() |> Logger.warn()
        []

      {:error, reason} ->
        reason |> inspect() |> Logger.warn()
        []
    end)
    |> Flow.partition(key: {:key, :id})
    |> Flow.group_by(& &1.id, & &1)
    |> Flow.map(fn {k, v} ->
      case Hotels.get_hotel(k) do
        nil ->
          v |> Enum.reduce(&Hotel.reducer/2) |> Hotels.create_hotel()

        hotel ->
          v
          |> Enum.reduce(to_plain_map(hotel), &Hotel.reducer/2)
          |> (&Hotels.update_hotel(hotel, &1)).()
      end
    end)
    |> Flow.partition()
    |> Flow.reduce(fn -> [] end, fn result, hotels ->
      case result do
        {:ok, hotel} ->
          [hotel | hotels]

        {:error, reason} ->
          reason |> inspect() |> Logger.warn()
          hotels
      end
    end)
    |> Enum.reverse()
  end

  defp to_plain_map(%Hotel{} = hotel) do
    %{
      id: hotel.id,
      destination_id: hotel.destination_id,
      name: hotel.name,
      location: to_plain_map(hotel.location),
      description: hotel.description,
      amenities: hotel.amenities,
      images: to_plain_map(hotel.images),
      booking_conditions: to_plain_map(hotel.booking_conditions)
    }
  end

  defp to_plain_map(%Location{} = location) do
    %{
      lat: location.lat,
      lng: location.lng,
      address: location.address,
      city: location.city,
      country: location.country
    }
  end

  defp to_plain_map(%Image{} = image) do
    %{
      id: image.id,
      hotel_id: image.hotel_id,
      type: image.type,
      link: image.link,
      description: image.description
    }
  end

  defp to_plain_map(%BookingCondition{} = booking_condition) do
    %{
      id: booking_condition.id,
      booking_condition: booking_condition.booking_condition
    }
  end

  defp to_plain_map(xs) when is_list(xs), do: Enum.map(xs, &to_plain_map/1)
  defp to_plain_map(any), do: any
end
