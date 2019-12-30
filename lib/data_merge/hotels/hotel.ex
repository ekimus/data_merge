defmodule DataMerge.Hotels.Hotel do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias DataMerge.Hotels.Hotel
  alias DataMerge.Hotels.Hotel.Amenity
  alias DataMerge.Hotels.Hotel.BookingCondition
  alias DataMerge.Hotels.Hotel.Image
  alias DataMerge.Hotels.Hotel.Location

  @primary_key {:id, :string, autogenerate: false}
  schema "hotels" do
    field :destination_id, :integer
    field :name, :string
    has_one :location, Location
    field :description, :string
    has_many :images, Image
    has_many :booking_conditions, BookingCondition
    many_to_many :amenities, Amenity, join_through: "hotel_amenities"
  end

  @permitted ~w(id destination_id name description)a
  @required ~w(id destination_id name description)a

  @doc false
  def changeset(%Hotel{} = hotel, %{} = attrs) do
    hotel
    |> cast(attrs, @permitted)
    |> validate_required(@required)
    |> cast_assoc(:location, required: true)
    |> cast_assoc(:amenities, required: true)
    |> cast_assoc(:images, required: true)
    |> cast_assoc(:booking_conditions, required: true)
  end

  @spec reducer(DataMerge.Hotels.Hotel.t(), DataMerge.Hotels.Hotel.t()) ::
          DataMerge.Hotels.Hotel.t()
  def reducer(%Hotel{} = a, %Hotel{} = b), do: Map.merge(a, b, &merger/3)

  defp merger(:amenities, a, b) do
    (a ++ b)
    |> Enum.group_by(& &1.type, & &1.amenity)
    |> Map.to_list()
    |> Enum.flat_map(fn {k, v} ->
      v
      |> Enum.sort()
      |> Enum.uniq()
      |> Enum.map(&%Amenity{type: k, amenity: &1})
    end)
  end

  defp merger(:images, a, b) do
    (a ++ b)
    |> Enum.group_by(& &1.type, &%{link: &1.link, description: &1.description})
    |> Map.to_list()
    |> Enum.flat_map(fn {k, v} ->
      v
      |> Enum.sort()
      |> Enum.uniq()
      |> Enum.map(&%Image{type: k, link: &1.link, description: &1.description})
    end)
  end

  defp merger(:booking_conditions, a, b), do: (a ++ b) |> Enum.sort() |> Enum.uniq()
  defp merger(:location, a, b), do: Map.merge(a, b, &merger/3)
  defp merger(_, nil, b), do: b
  defp merger(_, a, nil), do: a
  defp merger(_, _, b), do: b
end
