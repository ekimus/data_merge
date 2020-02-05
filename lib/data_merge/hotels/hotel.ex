defmodule DataMerge.Hotels.Hotel do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false

  alias DataMerge.Hotels.Hotel
  alias DataMerge.Hotels.Hotel.Amenity
  alias DataMerge.Hotels.Hotel.BookingCondition
  alias DataMerge.Hotels.Hotel.Image

  @primary_key {:id, :string, autogenerate: false}
  schema "hotels" do
    field :destination_id, :integer
    field :name, :string
    field :lat, :decimal
    field :lng, :decimal
    field :address, :string
    field :city, :string
    field :country, :string
    field :description, :string
    has_many :images, Image, on_replace: :delete
    has_many :booking_conditions, BookingCondition, on_replace: :delete
    many_to_many :amenities, Amenity, join_through: "hotel_amenities", on_replace: :delete
  end

  @permitted ~w(id destination_id name lat lng address city country description)a
  @required ~w(id destination_id name)a

  @doc false
  def changeset(%Hotel{} = hotel, %{} = attrs) do
    hotel
    |> cast(attrs, @permitted)
    |> validate_required(@required)
    |> cast_assoc(:images, required: true)
    |> cast_assoc(:booking_conditions)
    |> put_assoc(:amenities, Map.get(attrs, :amenities, []))
  end

  @spec reducer(map, map) :: map
  def reducer(%{} = a, %{} = b), do: Map.merge(a, b, &merger/3)

  defp merger(_, nil, b), do: b
  defp merger(_, a, nil), do: a
  defp merger(:name, a, b), do: longer(a, b)
  defp merger(:address, a, b), do: longer(a, b)
  defp merger(:city, a, b), do: longer(a, b)
  defp merger(:country, a, b), do: longer(a, b)
  defp merger(:description, a, b), do: longer(a, b)
  defp merger(:amenities, a, b) when is_list(a) and is_list(b), do: merge_on_type(a, b)
  defp merger(:images, a, b) when is_list(a) and is_list(b), do: merge_on_type(a, b)
  defp merger(:booking_conditions, a, b) when is_list(a) and is_list(b), do: sort_uniq(a ++ b)
  defp merger(_, _, b), do: b

  defp merge_on_type(a, b) do
    (a ++ b)
    |> Enum.group_by(& &1.type, & &1)
    |> Enum.flat_map(fn {_k, v} -> sort_uniq(v) end)
  end

  defp sort_uniq(xs), do: xs |> Enum.sort() |> Enum.uniq()

  defp longer(a, b), do: if(String.length(a) > String.length(b), do: a, else: b)
end
