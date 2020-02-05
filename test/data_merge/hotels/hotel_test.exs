defmodule DataMerge.Hotels.HotelTest do
  @moduledoc false

  use DataMerge.DataCase, async: true

  alias DataMerge.Hotels.Hotel

  describe "changeset/2" do
    @valid_attrs %{
      id: "id",
      destination_id: 1,
      name: "name",
      lat: 0.0,
      lng: 0.0,
      address: "address",
      city: "city",
      country: "country",
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
               images: ["can't be blank"]
             } = errors_on(changeset)
    end
  end

  describe "reducer/2" do
    test "prefer non-nil values" do
      a = %{
        id: "id",
        destination_id: nil,
        name: "name",
        lat: nil,
        lng: 0.0,
        address: nil,
        city: "city",
        country: nil,
        description: "description",
        amenities: nil,
        images: [],
        booking_conditions: nil
      }

      b = %{
        id: nil,
        destination_id: 1,
        name: nil,
        lat: 0.0,
        lng: nil,
        address: "address",
        city: nil,
        country: "country",
        description: nil,
        amenities: [],
        images: nil,
        booking_conditions: []
      }

      assert %{
               id: "id",
               destination_id: 1,
               name: "name",
               lat: 0.0,
               lng: 0.0,
               address: "address",
               city: "city",
               country: "country",
               description: "description",
               amenities: [],
               images: [],
               booking_conditions: []
             } = Hotel.reducer(a, b)
    end

    test "prefer singular values from second map" do
      a = %{
        id: "id",
        destination_id: 1,
        name: "name",
        lat: 0.0,
        lng: 0.0,
        address: "address",
        city: "city",
        country: "country",
        description: "description"
      }

      b = %{
        id: "idx",
        destination_id: 1,
        name: "namex",
        lat: 1.0,
        lng: 1.0,
        address: "addressx",
        city: "cityx",
        country: "countryx",
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
      a = %{address: "longer"}
      b = %{address: "long"}
      assert %{address: "longer"} = Hotel.reducer(a, b)
    end

    test "prefer longer country" do
      a = %{country: "longer"}
      b = %{country: "long"}
      assert %{country: "longer"} = Hotel.reducer(a, b)
    end

    test "prefer longer description" do
      a = %Hotel{description: "longer"}
      b = %Hotel{description: "long"}
      assert %Hotel{description: "longer"} = Hotel.reducer(a, b)
    end

    test "creates union of amenities" do
      a = %{
        amenities: [
          %{type: "general", amenity: "business center"},
          %{type: "general", amenity: "childcare"},
          %{type: "general", amenity: "indoor pool"},
          %{type: "room", amenity: "bathtub"},
          %{type: "room", amenity: "coffee machine"},
          %{type: "room", amenity: "iron"},
          %{type: "room", amenity: "kettle"},
          %{type: "room", amenity: "tv"}
        ]
      }

      b = %{
        amenities: [
          %{type: "general", amenity: "business center"},
          %{type: "general", amenity: "outdoor pool"},
          %{type: "room", amenity: "aircon"},
          %{type: "room", amenity: "bathtub"},
          %{type: "room", amenity: "coffee machine"},
          %{type: "room", amenity: "hair dryer"}
        ]
      }

      expected = %{
        amenities: [
          %{type: "general", amenity: "business center"},
          %{type: "general", amenity: "childcare"},
          %{type: "general", amenity: "indoor pool"},
          %{type: "general", amenity: "outdoor pool"},
          %{type: "room", amenity: "aircon"},
          %{type: "room", amenity: "bathtub"},
          %{type: "room", amenity: "coffee machine"},
          %{type: "room", amenity: "hair dryer"},
          %{type: "room", amenity: "iron"},
          %{type: "room", amenity: "kettle"},
          %{type: "room", amenity: "tv"}
        ]
      }

      actual = Hotel.reducer(a, b)
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

      actual = Hotel.reducer(a, b)
      assert actual == expected
    end

    test "creates union of booking_conditions" do
      a = %{booking_conditions: ["bar", "baz"]}
      b = %{booking_conditions: ["bar", "foo"]}
      expected = %{booking_conditions: ["bar", "baz", "foo"]}
      actual = Hotel.reducer(a, b)
      assert actual == expected
    end
  end
end
