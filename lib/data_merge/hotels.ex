defmodule DataMerge.Hotels do
  @moduledoc """
  The Hotels context.
  """

  import Ecto.Query, warn: false
  alias DataMerge.Hotels.Hotel
  alias DataMerge.Repo

  @doc """
  Creates a hotel.

  ## Examples

      iex> create_hotel(%{field: value})
      {:ok, %Hotel{}}

      iex> create_hotel(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_hotel(attrs) do
    %Hotel{}
    |> Hotel.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns a list of hotels.

  ## Examples

      iex> list_hotels()
      [%Hotel{}, ...]

  """
  def list_hotels do
    Hotel |> preload([:location, :amenities, :images, :booking_conditions]) |> Repo.all()
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
end
