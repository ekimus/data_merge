defmodule DataMerge.Hotels.Hotel.Location do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias DataMerge.Hotels.Hotel
  alias DataMerge.Hotels.Hotel.Location

  @primary_key false
  schema "locations" do
    belongs_to :hotel, Hotel, type: :string, primary_key: true
    field :lat, :decimal
    field :lng, :decimal
    field :address, :string
    field :city, :string
    field :country, :string
  end

  @permitted ~w(lat lng address city country)a
  @required ~w(address city country)a

  @doc false
  def changeset(%Location{} = location, %{} = attrs) do
    location
    |> cast(attrs, @permitted)
    |> validate_required(@required)
  end
end
