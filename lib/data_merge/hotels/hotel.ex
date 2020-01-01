defmodule DataMerge.Hotels.Hotel do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false

  alias DataMerge.Hotels.Hotel
  alias DataMerge.Hotels.Hotel.Amenity
  alias DataMerge.Hotels.Hotel.BookingCondition
  alias DataMerge.Hotels.Hotel.Image
  alias DataMerge.Hotels.Hotel.Location
  alias DataMerge.Repo

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
    |> cast_assoc(:images, required: true)
    |> cast_assoc(:booking_conditions, required: true)
    |> put_assoc(:amenities, attrs |> Map.get(:amenities, []) |> insert_amenities())
  end

  defp insert_amenities([]), do: []

  defp insert_amenities(xs) do
    types = Enum.map(xs, & &1.type)
    amenities = Enum.map(xs, & &1.amenity)
    _ = Repo.insert_all(Amenity, xs, on_conflict: :nothing)

    Amenity
    |> where([a], a.type in ^types)
    |> where([a], a.amenity in ^amenities)
    |> Repo.all()
  end

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
  defp merger(:name, a, b), do: if(String.length(a) > String.length(b), do: a, else: b)
  defp merger(_, _, b), do: b
end
