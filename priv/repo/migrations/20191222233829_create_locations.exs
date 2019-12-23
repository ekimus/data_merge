defmodule DataMerge.Repo.Migrations.CreateLocations do
  use Ecto.Migration

  def change do
    create table(:locations, primary_key: false) do
      add :hotel_id, references(:hotels, type: :string), primary_key: true
      add :lat, :decimal, null: false
      add :lng, :decimal, null: false
      add :address, :string, null: false
      add :city, :string, null: false
      add :country, :string, null: false
    end
  end
end
