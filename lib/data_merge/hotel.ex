defmodule DataMerge.Hotel do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias DataMerge.Hotel
  alias DataMerge.Hotel.BookingCondition

  @primary_key {:id, :string, autogenerate: false}
  schema "hotels" do
    field :destination_id, :integer
    field :name, :string
    field :description, :string
    has_many :booking_conditions, BookingCondition
  end

  @permitted ~w(id destination_id name description)a
  @required ~w(id destination_id name description)a

  @doc false
  def changeset(%Hotel{} = hotel, %{} = attrs) do
    hotel
    |> cast(attrs, @permitted)
    |> validate_required(@required)
  end
end
