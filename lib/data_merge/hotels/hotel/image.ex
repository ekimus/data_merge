defmodule DataMerge.Hotels.Hotel.Image do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias DataMerge.Hotels.Hotel
  alias DataMerge.Hotels.Hotel.Image

  schema "images" do
    belongs_to :hotel, Hotel, type: :string
    field :type, :string
    field :link, :string
    field :description, :string
  end

  @permitted ~w(type link description)a
  @required ~w(type link description)a

  @doc false
  def changeset(%Image{} = image, %{} = attrs) do
    image
    |> cast(attrs, @permitted)
    |> validate_required(@required)
  end
end
