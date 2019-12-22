defmodule DataMerge.Repo.Migrations.CreateImages do
  use Ecto.Migration

  def change do
    create table(:images) do
      add :hotel_id, references(:hotels, type: :string), null: false
      add :type, :string, null: false
      add :link, :text, null: false
      add :description, :string, null: false
    end

    create index(:images, [:hotel_id])
  end
end
