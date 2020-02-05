defmodule DataMerge.Repo.Migrations.CreateHotels do
  use Ecto.Migration

  def change do
    create table(:hotels, primary_key: false) do
      add :id, :string, primary_key: true
      add :destination_id, :integer, null: false
      add :lat, :decimal, null: true
      add :lng, :decimal, null: true
      add :address, :string, null: true
      add :city, :string, null: true
      add :country, :string, null: true
      add :name, :string, null: false
      add :description, :text, null: true
    end

    create index(:hotels, [:destination_id])
  end
end
