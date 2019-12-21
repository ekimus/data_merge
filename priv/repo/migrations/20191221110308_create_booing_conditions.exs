defmodule DataMerge.Repo.Migrations.CreateBooingConditions do
  use Ecto.Migration

  def change do
    create table(:booking_conditions) do
      add :hotel_id, references(:hotels, type: :string), null: false
      add :booking_condition, :text, null: false
    end

    create(index(:booking_conditions, [:hotel_id]))
  end
end
