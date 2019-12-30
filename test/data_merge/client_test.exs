defmodule DataMerge.ClientTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias DataMerge.Client


  describe "reducer/2" do
    test "chooses non-nil single values" do
      a = %{
        id: "id",
        destination_id: nil,
        name: "name",
        location: %{
          lat: nil,
          lng: 0.0,
          address: nil,
          city: "city",
          country: nil
        },
        description: "description",
        amenities: [],
        images: [],
        booking_conditions: []
      }

      b = %{
        id: nil,
        destination_id: 1,
        name: nil,
        location: %{
          lat: 0.0,
          lng: nil,
          address: "address",
          city: nil,
          country: "country"
        },
        description: nil,
        amenities: [],
        images: [],
        booking_conditions: []
      }

      expected = %{
        id: "id",
        destination_id: 1,
        name: "name",
        location: %{
          lat: 0.0,
          lng: 0.0,
          address: "address",
          city: "city",
          country: "country"
        },
        description: "description",
        amenities: [],
        images: [],
        booking_conditions: []
      }

      actual = Client.reducer(a, b)
      assert actual == expected
    end

    test "prefers singular values from second map" do
      a = %{
        id: "id",
        destination_id: 1,
        name: "name",
        location: %{
          lat: 0.0,
          lng: 0.0,
          address: "address",
          city: "city",
          country: "country"
        },
        description: "description",
        amenities: [],
        images: [],
        booking_conditions: []
      }

      b = %{
        id: "idx",
        destination_id: 1,
        name: "namex",
        location: %{
          lat: 1.0,
          lng: 1.0,
          address: "addressx",
          city: "cityx",
          country: "countryx"
        },
        description: "descriptionx",
        amenities: [],
        images: [],
        booking_conditions: []
      }

      actual = Client.reducer(a, b)
      assert actual == b
    end

    test "creates union of amenities" do
      a = %{
        amenities: [
          %{type: "general", amenity: "indoor pool"},
          %{type: "general", amenity: "business center"},
          %{type: "general", amenity: "childcare"},
          %{type: "room", amenity: "tv"},
          %{type: "room", amenity: "coffee machine"},
          %{type: "room", amenity: "kettle"},
          %{type: "room", amenity: "iron"},
          %{type: "room", amenity: "tub"}
        ]
      }

      b = %{
        amenities: [
          %{type: "general", amenity: "outdoor pool"},
          %{type: "general", amenity: "business center"},
          %{type: "room", amenity: "aircon"},
          %{type: "room", amenity: "coffee machine"},
          %{type: "room", amenity: "hair dryer"},
          %{type: "room", amenity: "tub"}
        ]
      }

      expected = %{
        amenities: [
          %{type: "general", amenity: "business center"},
          %{type: "general", amenity: "childcare"},
          %{type: "general", amenity: "indoor pool"},
          %{type: "general", amenity: "outdoor pool"},
          %{type: "room", amenity: "aircon"},
          %{type: "room", amenity: "coffee machine"},
          %{type: "room", amenity: "hair dryer"},
          %{type: "room", amenity: "iron"},
          %{type: "room", amenity: "kettle"},
          %{type: "room", amenity: "tub"},
          %{type: "room", amenity: "tv"}
        ]
      }

      actual = Client.reducer(a, b)
      assert actual == expected
    end

    test "creates union of images" do
      a = %{
        images: [
          %{
            type: "rooms",
            link: "https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/2.jpg",
            description: "Double room"
          },
          %{
            type: "rooms",
            link: "https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/3.jpg",
            description: "Double room"
          }
        ]
      }

      b = %{
        images: [
          %{
            type: "rooms",
            link: "https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/2.jpg",
            description: "Double room"
          },
          %{
            type: "site",
            link: "https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/1.jpg",
            description: "Front"
          }
        ]
      }

      expected = %{
        images: [
          %{
            type: "rooms",
            link: "https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/2.jpg",
            description: "Double room"
          },
          %{
            type: "rooms",
            link: "https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/3.jpg",
            description: "Double room"
          },
          %{
            type: "site",
            link: "https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/1.jpg",
            description: "Front"
          }
        ]
      }

      actual = Client.reducer(a, b)
      assert actual == expected
    end

    test "creates union of booking_conditions" do
      a = %{booking_conditions: ["bar", "baz"]}
      b = %{booking_conditions: ["bar", "foo"]}
      expected = %{booking_conditions: ["bar", "baz", "foo"]}
      actual = Client.reducer(a, b)
      assert actual == expected
    end
  end
end
