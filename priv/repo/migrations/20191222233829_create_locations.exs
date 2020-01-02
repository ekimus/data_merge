defmodule DataMerge.Repo.Migrations.CreateLocations do
  use Ecto.Migration

  def change do
    create table(:locations, primary_key: false) do
      add :hotel_id, references(:hotels, type: :string), primary_key: true
      add :lat, :decimal, null: true
      add :lng, :decimal, null: true
      add :address, :string, null: true
      add :city, :string, null: true
      add :country, :string, null: true
    end
  end
end
