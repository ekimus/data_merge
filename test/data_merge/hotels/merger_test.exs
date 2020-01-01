defmodule DataMerge.Hotels.MergerTest do
  use DataMerge.DataCase, async: false

  alias DataMerge.Hotels.Hotel
  alias DataMerge.Hotels.Hotel.Amenity
  alias DataMerge.Hotels.Merger
  alias DataMerge.Hotels.Normaliser.First
  alias DataMerge.Hotels.Normaliser.Second
  alias DataMerge.Hotels.Normaliser.Third
  alias DataMerge.Hotels.Resource

  describe "merge/1" do
    test "merges resources" do
      resources = [
        %Resource{uri: "http://localhost:4001/gdmqa", normaliser: First},
        %Resource{uri: "http://localhost:4001/1fva3m", normaliser: Second},
        %Resource{uri: "http://localhost:4001/j6kzm", normaliser: Third}
      ]

      assert [
               %Hotel{
                 id: "SjyX",
                 destination_id: 5432,
                 amenities: [
                   %Amenity{type: "general", amenity: "bar"},
                   %Amenity{type: "general", amenity: "breakfast"},
                   %Amenity{type: "general", amenity: "business center"},
                   %Amenity{type: "general", amenity: "childcare"},
                   %Amenity{type: "general", amenity: "concierge"},
                   %Amenity{type: "general", amenity: "dry cleaning"},
                   %Amenity{type: "general", amenity: "outdoor pool"},
                   %Amenity{type: "general", amenity: "parking"},
                   %Amenity{type: "general", amenity: "wifi"},
                   %Amenity{type: "room", amenity: "aircon"},
                   %Amenity{type: "room", amenity: "bath tub"},
                   %Amenity{type: "room", amenity: "hair dryer"},
                   %Amenity{type: "room", amenity: "minibar"},
                   %Amenity{type: "room", amenity: "tv"}
                 ],
                 booking_conditions: []
               },
               %Hotel{id: "f8c9"},
               %Hotel{id: "iJhz"}
             ] = Merger.merge(resources)
    end
  end
end
