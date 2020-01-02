# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     DataMerge.Repo.insert!(%DataMerge.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

DataMerge.Repo.insert_all(
  DataMerge.Hotels.Hotel.Amenity,
  [
    %{type: "general", amenity: "bar"},
    %{type: "general", amenity: "breakfast"},
    %{type: "general", amenity: "business center"},
    %{type: "general", amenity: "childcare"},
    %{type: "general", amenity: "concierge"},
    %{type: "general", amenity: "dry cleaning"},
    %{type: "general", amenity: "indoor pool"},
    %{type: "general", amenity: "outdoor pool"},
    %{type: "general", amenity: "parking"},
    %{type: "general", amenity: "wifi"},
    %{type: "room", amenity: "aircon"},
    %{type: "room", amenity: "bathtub"},
    %{type: "room", amenity: "coffee machine"},
    %{type: "room", amenity: "hair dryer"},
    %{type: "room", amenity: "iron"},
    %{type: "room", amenity: "kettle"},
    %{type: "room", amenity: "minibar"},
    %{type: "room", amenity: "tv"}
  ],
  on_conflict: :nothing
)
