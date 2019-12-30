defmodule DataMerge.Hotels.HotelTest do
  @moduledoc false

  use DataMerge.DataCase, async: true

  alias DataMerge.Hotels.Hotel
  alias DataMerge.Hotels.Hotel.Amenity
  alias DataMerge.Hotels.Hotel.Image
  alias DataMerge.Hotels.Hotel.Location

  describe "changeset/2" do
    @valid_attrs %{
      id: "id",
      destination_id: 1,
      name: "name",
      location: %{lat: 0.0, lng: 0.0, address: "address", city: "city", country: "country"},
      description: "description",
      amenities: [%{type: "type", amenity: "amenity"}],
      images: [%{type: "type", link: "link", description: "description"}],
      booking_conditions: [%{booking_condition: "booking_condition"}]
    }

    test "valid fields" do
      changeset = Hotel.changeset(%Hotel{}, @valid_attrs)
      assert changeset.valid?
    end

    test "required fields" do
      changeset = Hotel.changeset(%Hotel{}, %{})

      assert %{
               id: ["can't be blank"],
               destination_id: ["can't be blank"],
               name: ["can't be blank"],
               location: ["can't be blank"],
               description: ["can't be blank"],
               amenities: ["can't be blank"],
               images: ["can't be blank"],
               booking_conditions: ["can't be blank"]
             } = errors_on(changeset)
    end
  end

  describe "reducer/2" do
    test "chooses non-nil single values" do
      a = %Hotel{
        id: "id",
        destination_id: nil,
        name: "name",
        location: %Location{
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

      b = %Hotel{
        id: nil,
        destination_id: 1,
        name: nil,
        location: %Location{
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

      expected = %Hotel{
        id: "id",
        destination_id: 1,
        name: "name",
        location: %Location{
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

      actual = Hotel.reducer(a, b)
      assert actual == expected
    end

    test "prefers singular values from second map" do
      a = %Hotel{
        id: "id",
        destination_id: 1,
        name: "name",
        location: %Location{
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

      b = %Hotel{
        id: "idx",
        destination_id: 1,
        name: "namex",
        location: %Location{
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

      actual = Hotel.reducer(a, b)
      assert actual == b
    end

    test "creates union of amenities" do
      a = %Hotel{
        amenities: [
          %Amenity{type: "general", amenity: "indoor pool"},
          %Amenity{type: "general", amenity: "business center"},
          %Amenity{type: "general", amenity: "childcare"},
          %Amenity{type: "room", amenity: "tv"},
          %Amenity{type: "room", amenity: "coffee machine"},
          %Amenity{type: "room", amenity: "kettle"},
          %Amenity{type: "room", amenity: "iron"},
          %Amenity{type: "room", amenity: "tub"}
        ],
        images: [],
        booking_conditions: []
      }

      b = %Hotel{
        amenities: [
          %Amenity{type: "general", amenity: "outdoor pool"},
          %Amenity{type: "general", amenity: "business center"},
          %Amenity{type: "room", amenity: "aircon"},
          %Amenity{type: "room", amenity: "coffee machine"},
          %Amenity{type: "room", amenity: "hair dryer"},
          %Amenity{type: "room", amenity: "tub"}
        ],
        images: [],
        booking_conditions: []
      }

      expected = %Hotel{
        amenities: [
          %Amenity{type: "general", amenity: "business center"},
          %Amenity{type: "general", amenity: "childcare"},
          %Amenity{type: "general", amenity: "indoor pool"},
          %Amenity{type: "general", amenity: "outdoor pool"},
          %Amenity{type: "room", amenity: "aircon"},
          %Amenity{type: "room", amenity: "coffee machine"},
          %Amenity{type: "room", amenity: "hair dryer"},
          %Amenity{type: "room", amenity: "iron"},
          %Amenity{type: "room", amenity: "kettle"},
          %Amenity{type: "room", amenity: "tub"},
          %Amenity{type: "room", amenity: "tv"}
        ],
        images: [],
        booking_conditions: []
      }

      actual = Hotel.reducer(a, b)
      assert actual == expected
    end

    test "creates union of images" do
      a = %Hotel{
        amenities: [],
        images: [
          %Image{
            type: "rooms",
            link: "https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/2.jpg",
            description: "Double room"
          },
          %Image{
            type: "rooms",
            link: "https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/3.jpg",
            description: "Double room"
          }
        ],
        booking_conditions: []
      }

      b = %Hotel{
        amenities: [],
        images: [
          %Image{
            type: "rooms",
            link: "https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/2.jpg",
            description: "Double room"
          },
          %Image{
            type: "site",
            link: "https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/1.jpg",
            description: "Front"
          }
        ],
        booking_conditions: []
      }

      expected = %Hotel{
        amenities: [],
        images: [
          %Image{
            type: "rooms",
            link: "https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/2.jpg",
            description: "Double room"
          },
          %Image{
            type: "rooms",
            link: "https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/3.jpg",
            description: "Double room"
          },
          %Image{
            type: "site",
            link: "https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/1.jpg",
            description: "Front"
          }
        ],
        booking_conditions: []
      }

      actual = Hotel.reducer(a, b)
      assert actual == expected
    end

    test "creates union of booking_conditions" do
      a = %Hotel{amenities: [], images: [], booking_conditions: ["bar", "baz"]}
      b = %Hotel{amenities: [], images: [], booking_conditions: ["bar", "foo"]}
      expected = %Hotel{amenities: [], images: [], booking_conditions: ["bar", "baz", "foo"]}
      actual = Hotel.reducer(a, b)
      assert actual == expected
    end
  end
end
