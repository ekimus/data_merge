defmodule DataMerge.Repo.Migrations.CreateHotelAmenities do
  use Ecto.Migration

  def change do
    create table(:hotel_amenities, primary_key: false) do
      add :hotel_id, references(:hotels, type: :string), primary_key: true
      add :amenity_id, references(:amenities), primary_key: true
    end

    create index(:hotel_amenities, [:hotel_id])
    create index(:hotel_amenities, [:amenity_id])
  end
end
