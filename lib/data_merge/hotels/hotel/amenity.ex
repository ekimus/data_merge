defmodule DataMerge.Hotels.Hotel.Amenity do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias DataMerge.Hotels.Hotel
  alias DataMerge.Hotels.Hotel.Amenity

  schema "amenities" do
    field :type, :string
    field :amenity, :string
    many_to_many :hotels, Hotel, join_through: "hotel_amenities"
  end

  @permitted ~w(type amenity)a
  @required ~w(type amenity)a

  @doc false
  def changeset(%Amenity{} = amenity, %{} = attrs) do
    amenity
    |> cast(attrs, @permitted)
    |> validate_required(@required)
    |> unique_constraint(:amenity, name: :amenities_type_amenity_index)
  end
end
