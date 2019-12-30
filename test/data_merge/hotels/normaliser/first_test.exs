defmodule DataMerge.Hotels.Normaliser.FirstTest do
  use ExUnit.Case, async: true

  alias DataMerge.Hotels.Hotel
  alias DataMerge.Hotels.Hotel.Amenity
  alias DataMerge.Hotels.Hotel.Location
  alias DataMerge.Hotels.Normaliser.First

  describe "normalise/1" do
    @data %{
      "Id" => "iJhz",
      "DestinationId" => 5432,
      "Name" => "Beach Villas Singapore",
      "Latitude" => 1.264751,
      "Longitude" => 103.824006,
      "Address" => " 8 Sentosa Gateway, Beach Villas ",
      "City" => "Singapore",
      "Country" => "SG",
      "PostalCode" => "098269",
      "Description" => "  This 5 star hotel is located on the coastline of Singapore.",
      "Facilities" => [
        "Pool",
        "BusinessCenter",
        "WiFi ",
        "DryCleaning",
        " Breakfast"
      ]
    }

    test "returns normalised map" do
      expected = %Hotel{
        id: "iJhz",
        destination_id: 5432,
        name: "Beach Villas Singapore",
        location: %Location{
          lat: 1.264751,
          lng: 103.824006,
          address: "8 Sentosa Gateway, Beach Villas, 098269",
          city: "Singapore",
          country: "SG"
        },
        description: "This 5 star hotel is located on the coastline of Singapore.",
        amenities: [
          %Amenity{type: "general", amenity: "pool"},
          %Amenity{type: "general", amenity: "businesscenter"},
          %Amenity{type: "general", amenity: "wifi"},
          %Amenity{type: "general", amenity: "drycleaning"},
          %Amenity{type: "general", amenity: "breakfast"}
        ],
        images: [],
        booking_conditions: []
      }

      actual = First.normalise(@data)
      assert actual == expected
    end

    test "nil handling" do
      expected = %Hotel{
        id: nil,
        destination_id: nil,
        name: nil,
        location: %Location{lat: nil, lng: nil, address: nil, city: nil, country: nil},
        description: nil,
        amenities: [],
        images: [],
        booking_conditions: []
      }

      actual = First.normalise(%{})
      assert actual == expected
    end
  end
end
