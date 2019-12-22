defmodule DataMerge.Hotels.Hotel.BookingCondition do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias DataMerge.Hotels.Hotel
  alias DataMerge.Hotels.Hotel.BookingCondition

  schema "booking_conditions" do
    field :booking_condition, :string
    belongs_to :hotel, Hotel, type: :string
  end

  @permitted ~w(booking_condition)a
  @required ~w(booking_condition)a

  @doc false
  def changeset(%BookingCondition{} = booking_condition, %{} = attrs) do
    booking_condition
    |> cast(attrs, @permitted)
    |> validate_required(@required)
  end
end
