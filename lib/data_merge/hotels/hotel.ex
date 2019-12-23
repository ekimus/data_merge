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
end
