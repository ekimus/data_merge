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
               images: ["can't be blank"],
               booking_conditions: ["can't be blank"]
             } = errors_on(changeset)
    end
  end

  describe "reducer/2" do
    test "prefer non-nil values" do
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
        amenities: nil,
        images: [],
        booking_conditions: nil
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
        images: nil,
        booking_conditions: []
      }

      assert %Hotel{
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
             } = Hotel.reducer(a, b)
    end

    test "prefer singular values from second map" do
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
        description: "description"
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
        description: "descriptionx"
      }

      actual = Hotel.reducer(a, b)
      assert actual == b
    end

    test "prefer longer name" do
      a = %Hotel{name: "longer"}
      b = %Hotel{name: "long"}
      assert %Hotel{name: "longer"} = Hotel.reducer(a, b)
    end

    test "prefer longer address" do
      a = %Hotel{location: %Location{address: "longer"}}
      b = %Hotel{location: %Location{address: "long"}}
      assert %Hotel{location: %Location{address: "longer"}} = Hotel.reducer(a, b)
    end

    test "prefer longer country" do
      a = %Hotel{location: %Location{country: "longer"}}
      b = %Hotel{location: %Location{country: "long"}}
      assert %Hotel{location: %Location{country: "longer"}} = Hotel.reducer(a, b)
    end

    test "prefer longer description" do
      a = %Hotel{description: "longer"}
      b = %Hotel{description: "long"}
      assert %Hotel{description: "longer"} = Hotel.reducer(a, b)
    end

    test "creates union of amenities" do
      a = %Hotel{
        amenities: [
          %Amenity{type: "general", amenity: "business center"},
          %Amenity{type: "general", amenity: "childcare"},
          %Amenity{type: "general", amenity: "indoor pool"},
          %Amenity{type: "room", amenity: "bath tub"},
          %Amenity{type: "room", amenity: "coffee machine"},
          %Amenity{type: "room", amenity: "iron"},
          %Amenity{type: "room", amenity: "kettle"},
          %Amenity{type: "room", amenity: "tv"}
        ]
      }

      b = %Hotel{
        amenities: [
          %Amenity{type: "general", amenity: "business center"},
          %Amenity{type: "general", amenity: "outdoor pool"},
          %Amenity{type: "room", amenity: "aircon"},
          %Amenity{type: "room", amenity: "bath tub"},
          %Amenity{type: "room", amenity: "coffee machine"},
          %Amenity{type: "room", amenity: "hair dryer"}
        ]
      }

      expected = %Hotel{
        amenities: [
          %Amenity{type: "general", amenity: "business center"},
          %Amenity{type: "general", amenity: "childcare"},
          %Amenity{type: "general", amenity: "indoor pool"},
          %Amenity{type: "general", amenity: "outdoor pool"},
          %Amenity{type: "room", amenity: "aircon"},
          %Amenity{type: "room", amenity: "bath tub"},
          %Amenity{type: "room", amenity: "coffee machine"},
          %Amenity{type: "room", amenity: "hair dryer"},
          %Amenity{type: "room", amenity: "iron"},
          %Amenity{type: "room", amenity: "kettle"},
          %Amenity{type: "room", amenity: "tv"}
        ]
      }

      actual = Hotel.reducer(a, b)
      assert actual == expected
    end

    test "creates union of images" do
      a = %Hotel{
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
        ]
      }

      b = %Hotel{
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
        ]
      }

      expected = %Hotel{
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
        ]
      }

      actual = Hotel.reducer(a, b)
      assert actual == expected
    end

    test "creates union of booking_conditions" do
      a = %Hotel{booking_conditions: ["bar", "baz"]}
      b = %Hotel{booking_conditions: ["bar", "foo"]}
      expected = %Hotel{booking_conditions: ["bar", "baz", "foo"]}
      actual = Hotel.reducer(a, b)
      assert actual == expected
    end
  end
end
