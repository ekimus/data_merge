defmodule DataMerge.Hotels do
  @moduledoc """
  The Hotels context.
  """

  import Ecto.Query, warn: false
  alias DataMerge.Hotels.Hotel
  alias DataMerge.Hotels.Hotel.Amenity
  alias DataMerge.Repo

  @doc """
  Creates a hotel.

  ## Examples

      iex> create_hotel(%{field: value})
      {:ok, %Hotel{}}

      iex> create_hotel(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_hotel(%{} = attrs) do
    %Hotel{}
    |> Hotel.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a hotel.

  ## Examples

      iex> update_hotel(%Hotel{}, %{field: value})
      {:ok, %Hotel{}}

      iex> update_hotel(%Hotel{}, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_hotel(%Hotel{} = hotel, %{} = attrs) do
    hotel
    |> Hotel.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Returns a list of hotels.

  ## Examples

      iex> list_hotels()
      [%Hotel{}, ...]

  """
  def list_hotels do
    Hotel
    |> preload([:location, :amenities, :images, :booking_conditions])
    |> Repo.all()
  end

  @doc """
  Returns a list of hotels with the given ids.

  ## Examples

      iex> hotels(ids)
      [%Hotel{}, ...]

  """
  def hotels(ids) do
    Hotel
    |> where([h], h.id in ^ids)
    |> preload([:location, :amenities, :images, :booking_conditions])
    |> Repo.all()
  end

  @doc """
  Returns a list of hotels with the given destination_id.

  ## Examples

      iex> destination(destination_id)
      [%Hotel{}, ...]

  """
  def destination(destination_id) do
    Hotel
    |> where(destination_id: ^destination_id)
    |> preload([:location, :amenities, :images, :booking_conditions])
    |> Repo.all()
  end

  @doc """
  Returns a hotel with the given id.

  ## Examples

      iex> get_hotels(id)
      %Hotel{}

  """
  def get_hotel(id) do
    Hotel
    |> preload([:location, :amenities, :images, :booking_conditions])
    |> Repo.get(id)
  end

  @doc """
  Returns a list of matching, near matching, and unmatched amenities

  ## Examples

      iex> amenities(amenities)
      {[%Amenity{}, ...], [%Amenity{}], ["unmatched"]}

  """
  def amenities(amenities) do
    all = MapSet.new(amenities)

    exact_matches =
      Amenity
      |> where([a], a.amenity in ^MapSet.to_list(all))
      |> Repo.all()

    remaining =
      exact_matches
      |> to_map_set()
      |> (&MapSet.difference(all, &1)).()

    {near_matches, near} =
      Amenity
      |> where([a], a.amenity not in ^MapSet.to_list(all))
      |> Repo.all()
      |> Enum.reduce({[], []}, fn x, {xs, ms} ->
        {ys, ns} = near_matches(remaining, x)
        {ys ++ xs, ns ++ ms}
      end)

    unmatched =
      remaining
      |> MapSet.difference(MapSet.new(near))
      |> MapSet.to_list()

    {exact_matches, near_matches, unmatched}
  end

  defp to_map_set(xs) do
    xs
    |> Enum.map(& &1.amenity)
    |> MapSet.new()
  end

  defp near_matches(remaining, amenity) do
    remaining
    |> Enum.map(&{String.jaro_distance(&1, amenity.amenity), amenity, &1})
    |> Enum.reduce({[], []}, fn t, {xs, ms} ->
      case t do
        {distance, x, m} when distance > 0.95 -> {[x | xs], [m | ms]}
        _ -> {xs, ms}
      end
    end)
  end
end
