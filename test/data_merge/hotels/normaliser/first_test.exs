defmodule DataMerge.Hotels.Normaliser.FirstTest do
  use DataMerge.DataCase, async: true

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
      %{
        id: "iJhz",
        destination_id: 5432,
        name: "Beach Villas Singapore",
        location: %{
          lat: 1.264751,
          lng: 103.824006,
          address: "8 Sentosa Gateway, Beach Villas, 098269",
          city: "Singapore",
          country: "SG"
        },
        description: "This 5 star hotel is located on the coastline of Singapore.",
        amenities: amenities,
        images: [],
        booking_conditions: []
      } = First.normalise(@data)

      expected = ["breakfast", "business center", "dry cleaning", "outdoor pool", "wifi"]
      actual = Enum.map(amenities, & &1.amenity)
      assert Enum.reduce(expected, true, &(&2 && &1 in actual))
    end

    test "empty map handling" do
      expected = %{
        id: nil,
        destination_id: nil,
        name: nil,
        location: %{lat: nil, lng: nil, address: nil, city: nil, country: nil},
        description: nil,
        amenities: [],
        images: [],
        booking_conditions: []
      }

      actual = First.normalise(%{})
      assert actual == expected
    end

    test "nil handling" do
      data = %{
        "Id" => nil,
        "DestinationId" => nil,
        "Name" => nil,
        "Latitude" => nil,
        "Longitude" => nil,
        "Address" => nil,
        "City" => nil,
        "Country" => nil,
        "PostalCode" => nil,
        "Description" => nil,
        "Facilities" => nil
      }

      expected = %{
        id: nil,
        destination_id: nil,
        name: nil,
        location: %{lat: nil, lng: nil, address: nil, city: nil, country: nil},
        description: nil,
        amenities: [],
        images: [],
        booking_conditions: []
      }

      actual = First.normalise(data)
      assert actual == expected
    end
  end
end
