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
  @spec changeset(DataMerge.Hotels.Hotel.t(), map) :: Ecto.Changeset.t()
  def changeset(%Hotel{} = hotel, %{} = attrs) do
    hotel
    |> cast(attrs, @permitted)
    |> validate_required(@required)
    |> cast_assoc(:location, required: true)
    |> cast_assoc(:images, required: true)
    |> cast_assoc(:booking_conditions)
    |> put_assoc(:amenities, Map.get(attrs, :amenities, []))
  end

  @spec reducer(map, map) :: map
  def reducer(%{} = a, %{} = b), do: Map.merge(a, b, &merger/3)

  defp merger(_, nil, b), do: b
  defp merger(_, a, nil), do: a
  defp merger(:name, a, b), do: longer(a, b)
  defp merger(:location, a, b), do: Map.merge(a, b, &merger/3)
  defp merger(:address, a, b), do: longer(a, b)
  defp merger(:country, a, b), do: longer(a, b)
  defp merger(:description, a, b), do: longer(a, b)
  defp merger(:amenities, a, b) when is_list(a) and is_list(b), do: merge_on_type(a, b)
  defp merger(:images, a, b) when is_list(a) and is_list(b), do: merge_on_type(a, b)
  defp merger(:booking_conditions, a, b) when is_list(a) and is_list(b), do: sort_uniq(a ++ b)
  defp merger(_, _, b), do: b

  defp merge_on_type(a, b) do
    (a ++ b)
    |> Enum.group_by(& &1.type, & &1)
    |> Map.to_list()
    |> Enum.flat_map(fn {_k, v} -> sort_uniq(v) end)
  end

  defp sort_uniq(xs), do: xs |> Enum.sort() |> Enum.uniq()

  defp longer(a, b), do: if(String.length(a) > String.length(b), do: a, else: b)
end
