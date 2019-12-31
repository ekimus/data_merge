defmodule DataMerge.Repo.Migrations.CreateHotels do
  use Ecto.Migration

  def change do
    create table(:hotels, primary_key: false) do
      add :id, :string, primary_key: true
      add :destination_id, :integer, null: false
      add :name, :string, null: false
      add :description, :text, null: false
    end

    create index(:hotels, [:destination_id])
  end
end
