defmodule DataMerge.Hotels.Normaliser.ThirdTest do
  use ExUnit.Case, async: true

  alias DataMerge.Hotels.Hotel
  alias DataMerge.Hotels.Hotel.Amenity
  alias DataMerge.Hotels.Hotel.Image
  alias DataMerge.Hotels.Hotel.Location
  alias DataMerge.Hotels.Normaliser.Third

  describe "normalise/1" do
    @data %{
      "id" => "iJhz",
      "destination" => 5432,
      "name" => "Beach Villas Singapore",
      "lat" => 1.264751,
      "lng" => 103.824006,
      "address" => "8 Sentosa Gateway, Beach Villas, 098269",
      "info" =>
        "Located at the western tip of Resorts World Sentosa, guests at the Beach Villas are guaranteed privacy while they enjoy spectacular views of glittering waters. Guests will find themselves in paradise with this series of exquisite tropical sanctuaries, making it the perfect setting for an idyllic retreat. Within each villa, guests will discover living areas and bedrooms that open out to mini gardens, private timber sundecks and verandahs elegantly framing either lush greenery or an expanse of sea. Guests are assured of a superior slumber with goose feather pillows and luxe mattresses paired with 400 thread count Egyptian cotton bed linen, tastefully paired with a full complement of luxurious in-room amenities and bathrooms boasting rain showers and free-standing tubs coupled with an exclusive array of ESPA amenities and toiletries. Guests also get to enjoy complimentary day access to the facilities at Asia’s flagship spa – the world-renowned ESPA.",
      "amenities" => [
        "Aircon",
        "Tv",
        "Coffee machine",
        "Kettle",
        "Hair dryer",
        "Iron",
        "Tub"
      ],
      "images" => %{
        "rooms" => [
          %{
            "url" => "https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/2.jpg",
            "description" => "Double room"
          },
          %{
            "url" => "https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/4.jpg",
            "description" => "Bathroom"
          }
        ],
        "amenities" => [
          %{
            "url" => "https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/0.jpg",
            "description" => "RWS"
          },
          %{
            "url" => "https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/6.jpg",
            "description" => "Sentosa Gateway"
          }
        ]
      }
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
          city: nil,
          country: nil
        },
        description:
          "Located at the western tip of Resorts World Sentosa, guests at the Beach Villas are guaranteed privacy while they enjoy spectacular views of glittering waters. Guests will find themselves in paradise with this series of exquisite tropical sanctuaries, making it the perfect setting for an idyllic retreat. Within each villa, guests will discover living areas and bedrooms that open out to mini gardens, private timber sundecks and verandahs elegantly framing either lush greenery or an expanse of sea. Guests are assured of a superior slumber with goose feather pillows and luxe mattresses paired with 400 thread count Egyptian cotton bed linen, tastefully paired with a full complement of luxurious in-room amenities and bathrooms boasting rain showers and free-standing tubs coupled with an exclusive array of ESPA amenities and toiletries. Guests also get to enjoy complimentary day access to the facilities at Asia’s flagship spa – the world-renowned ESPA.",
        amenities: [
          %Amenity{type: "room", amenity: "aircon"},
          %Amenity{type: "room", amenity: "tv"},
          %Amenity{type: "room", amenity: "coffee machine"},
          %Amenity{type: "room", amenity: "kettle"},
          %Amenity{type: "room", amenity: "hair dryer"},
          %Amenity{type: "room", amenity: "iron"},
          %Amenity{type: "room", amenity: "tub"}
        ],
        images: [
          %Image{
            type: "amenities",
            link: "https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/0.jpg",
            description: "RWS"
          },
          %Image{
            type: "amenities",
            link: "https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/6.jpg",
            description: "Sentosa Gateway"
          },
          %Image{
            type: "rooms",
            link: "https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/2.jpg",
            description: "Double room"
          },
          %Image{
            type: "rooms",
            link: "https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/4.jpg",
            description: "Bathroom"
          }
        ],
        booking_conditions: []
      }

      actual = Third.normalise(@data)
      assert actual == expected
    end

    test "nil handling" do
      expected = %Hotel{
        id: nil,
        destination_id: nil,
        name: nil,
        location: %Location{address: nil, city: nil, country: nil, lat: nil, lng: nil},
        description: nil,
        amenities: [],
        images: [],
        booking_conditions: []
      }

      actual = Third.normalise(%{})
      assert actual == expected
    end
  end
end
