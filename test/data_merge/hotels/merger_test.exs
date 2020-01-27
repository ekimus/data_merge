defmodule DataMerge.Hotels.MergerTest do
  use DataMerge.DataCase, async: false

  alias DataMerge.Hotels
  alias DataMerge.Hotels.Hotel
  alias DataMerge.Hotels.Hotel.Amenity
  alias DataMerge.Hotels.Hotel.BookingCondition
  alias DataMerge.Hotels.Hotel.Image
  alias DataMerge.Hotels.Hotel.Location
  alias DataMerge.Hotels.Merger
  alias DataMerge.Hotels.Normaliser.First
  alias DataMerge.Hotels.Normaliser.Second
  alias DataMerge.Hotels.Normaliser.Third

  @resources [
    %{uri: "http://localhost:4001/gdmqa.json", normaliser: First},
    %{uri: "http://localhost:4001/1fva3m.json", normaliser: Second},
    %{uri: "http://localhost:4001/j6kzm.json", normaliser: Third}
  ]

  describe "merge/1" do
    test "merges resources and saves to database" do
      Merger.merge(@resources)

      assert %Hotel{
               id: "iJhz",
               destination_id: 5432,
               name: "Beach Villas Singapore",
               location: %Location{
                 address: "8 Sentosa Gateway, Beach Villas, 098269",
                 city: "Singapore",
                 country: "Singapore",
                 lat: lat,
                 lng: lng
               },
               description:
                 "Located at the western tip of Resorts World Sentosa, guests at the Beach Villas are guaranteed privacy while they enjoy spectacular views of glittering waters. Guests will find themselves in paradise with this series of exquisite tropical sanctuaries, making it the perfect setting for an idyllic retreat. Within each villa, guests will discover living areas and bedrooms that open out to mini gardens, private timber sundecks and verandahs elegantly framing either lush greenery or an expanse of sea. Guests are assured of a superior slumber with goose feather pillows and luxe mattresses paired with 400 thread count Egyptian cotton bed linen, tastefully paired with a full complement of luxurious in-room amenities and bathrooms boasting rain showers and free-standing tubs coupled with an exclusive array of ESPA amenities and toiletries. Guests also get to enjoy complimentary day access to the facilities at Asia’s flagship spa – the world-renowned ESPA.",
               amenities: [
                 %Amenity{type: "general", amenity: "breakfast"},
                 %Amenity{type: "general", amenity: "business center"},
                 %Amenity{type: "general", amenity: "childcare"},
                 %Amenity{type: "general", amenity: "dry cleaning"},
                 %Amenity{type: "general", amenity: "indoor pool"},
                 %Amenity{type: "general", amenity: "outdoor pool"},
                 %Amenity{type: "general", amenity: "wifi"},
                 %Amenity{type: "room", amenity: "aircon"},
                 %Amenity{type: "room", amenity: "bathtub"},
                 %Amenity{type: "room", amenity: "coffee machine"},
                 %Amenity{type: "room", amenity: "hair dryer"},
                 %Amenity{type: "room", amenity: "iron"},
                 %Amenity{type: "room", amenity: "kettle"},
                 %Amenity{type: "room", amenity: "tv"}
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
                   link: "https://d2ey9sqrvkqdfs.cloudfront.net/0qZF/4.jpg",
                   description: "Bathroom"
                 },
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
               booking_conditions: [
                 %BookingCondition{
                   booking_condition:
                     "All children are welcome. One child under 12 years stays free of charge when using existing beds. One child under 2 years stays free of charge in a child's cot/crib. One child under 4 years stays free of charge when using existing beds. One older child or adult is charged SGD 82.39 per person per night in an extra bed. The maximum number of children's cots/cribs in a room is 1. There is no capacity for extra beds in the room."
                 },
                 %BookingCondition{
                   booking_condition:
                     "Free private parking is possible on site (reservation is not needed)."
                 },
                 %BookingCondition{
                   booking_condition:
                     "Guests are required to show a photo identification and credit card upon check-in. Please note that all Special Requests are subject to availability and additional charges may apply. Payment before arrival via bank transfer is required. The property will contact you after you book to provide instructions. Please note that the full amount of the reservation is due before arrival. Resorts World Sentosa will send a confirmation with detailed payment information. After full payment is taken, the property's details, including the address and where to collect keys, will be emailed to you. Bag checks will be conducted prior to entry to Adventure Cove Waterpark. === Upon check-in, guests will be provided with complimentary Sentosa Pass (monorail) to enjoy unlimited transportation between Sentosa Island and Harbour Front (VivoCity). === Prepayment for non refundable bookings will be charged by RWS Call Centre. === All guests can enjoy complimentary parking during their stay, limited to one exit from the hotel per day. === Room reservation charges will be charged upon check-in. Credit card provided upon reservation is for guarantee purpose. === For reservations made with inclusive breakfast, please note that breakfast is applicable only for number of adults paid in the room rate. Any children or additional adults are charged separately for breakfast and are to paid directly to the hotel."
                 },
                 %BookingCondition{booking_condition: "Pets are not allowed."},
                 %BookingCondition{
                   booking_condition: "WiFi is available in all areas and is free of charge."
                 }
               ]
             } = Hotels.get_hotel("iJhz")

      assert :eq = 1.264751 |> Decimal.from_float() |> Decimal.cmp(lat)
      assert :eq = 103.824006 |> Decimal.from_float() |> Decimal.cmp(lng)
      assert %Hotel{id: "SjyX"} = Hotels.get_hotel("SjyX")
      assert %Hotel{id: "f8c9"} = Hotels.get_hotel("f8c9")
    end

    test "merges new data" do
      Merger.merge([%{uri: "http://localhost:4001/j6kzm.json", normaliser: Third}])
      assert %Hotel{id: "iJhz"} = Hotels.get_hotel("iJhz")
      assert %Hotel{id: "f8c9"} = Hotels.get_hotel("f8c9")

      Merger.merge(@resources)
      assert %Hotel{id: "iJhz"} = Hotels.get_hotel("iJhz")
      assert %Hotel{id: "SjyX"} = Hotels.get_hotel("SjyX")
      assert %Hotel{id: "f8c9"} = Hotels.get_hotel("f8c9")
    end

    test "ignore stored amenities" do
      Merger.merge([%{uri: "http://localhost:4001/j6kzm.json", normaliser: Third}])

      assert %Hotel{
               id: "iJhz",
               amenities: [
                 %Amenity{type: "room", amenity: "aircon"},
                 %Amenity{type: "room", amenity: "bathtub"},
                 %Amenity{type: "room", amenity: "coffee machine"},
                 %Amenity{type: "room", amenity: "hair dryer"},
                 %Amenity{type: "room", amenity: "iron"},
                 %Amenity{type: "room", amenity: "kettle"},
                 %Amenity{type: "room", amenity: "tv"}
               ]
             } = Hotels.get_hotel("iJhz")

      Merger.merge([%{uri: "http://localhost:4001/1fva3m.json", normaliser: Second}])

      assert %Hotel{
               id: "iJhz",
               amenities: [
                 %Amenity{type: "room", amenity: "coffee machine"},
                 %Amenity{type: "room", amenity: "hair dryer"},
                 %Amenity{type: "room", amenity: "iron"},
                 %Amenity{type: "room", amenity: "kettle"},
                 %Amenity{type: "room", amenity: "tv"},
                 %Amenity{type: "general", amenity: "business center"},
                 %Amenity{type: "general", amenity: "childcare"},
                 %Amenity{type: "general", amenity: "indoor pool"},
                 %Amenity{type: "general", amenity: "outdoor pool"}
               ]
             } = Hotels.get_hotel("iJhz")
    end

    test "ignore stored booking_conditions" do
      Merger.merge([%{uri: "http://localhost:4001/1fva3m.json", normaliser: Second}])

      assert %Hotel{
               id: "iJhz",
               booking_conditions: [
                 %BookingCondition{
                   booking_condition:
                     "All children are welcome. One child under 12 years stays free of charge when using existing beds. One child under 2 years stays free of charge in a child's cot/crib. One child under 4 years stays free of charge when using existing beds. One older child or adult is charged SGD 82.39 per person per night in an extra bed. The maximum number of children's cots/cribs in a room is 1. There is no capacity for extra beds in the room."
                 },
                 %BookingCondition{booking_condition: "Pets are not allowed."},
                 %BookingCondition{
                   booking_condition: "WiFi is available in all areas and is free of charge."
                 },
                 %BookingCondition{
                   booking_condition:
                     "Free private parking is possible on site (reservation is not needed)."
                 },
                 %BookingCondition{
                   booking_condition:
                     "Guests are required to show a photo identification and credit card upon check-in. Please note that all Special Requests are subject to availability and additional charges may apply. Payment before arrival via bank transfer is required. The property will contact you after you book to provide instructions. Please note that the full amount of the reservation is due before arrival. Resorts World Sentosa will send a confirmation with detailed payment information. After full payment is taken, the property's details, including the address and where to collect keys, will be emailed to you. Bag checks will be conducted prior to entry to Adventure Cove Waterpark. === Upon check-in, guests will be provided with complimentary Sentosa Pass (monorail) to enjoy unlimited transportation between Sentosa Island and Harbour Front (VivoCity). === Prepayment for non refundable bookings will be charged by RWS Call Centre. === All guests can enjoy complimentary parking during their stay, limited to one exit from the hotel per day. === Room reservation charges will be charged upon check-in. Credit card provided upon reservation is for guarantee purpose. === For reservations made with inclusive breakfast, please note that breakfast is applicable only for number of adults paid in the room rate. Any children or additional adults are charged separately for breakfast and are to paid directly to the hotel."
                 }
               ]
             } = Hotels.get_hotel("iJhz")

      Merger.merge([%{uri: "http://localhost:4001/j6kzm.json", normaliser: Third}])
      assert %Hotel{id: "iJhz", booking_conditions: []} = Hotels.get_hotel("iJhz")
    end
  end
end
