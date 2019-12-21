defmodule DataMerge.Hotel do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias DataMerge.Hotel

  @primary_key false
  schema "hotels" do
    field :id, :string, primary_key: true
    field :destination_id, :integer
    field :name, :string
    field :description, :string
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
