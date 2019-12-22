defmodule DataMerge.Repo.Migrations.CreateAmenities do
  use Ecto.Migration

  def change do
    create table(:amenities) do
      add :type, :string, null: false
      add :amenity, :string, null: false
    end

    create unique_index(:amenities, [:type, :amenity])
  end
end
