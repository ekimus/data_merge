defmodule DataMerge.HotelControllerTest do
  use DataMergeWeb.ConnCase, async: true

  alias DataMerge.Hotels

  describe "index/2" do
    test "/ responds with all hotels", %{conn: conn} do
      {:ok, hotel} =
        Hotels.create_hotel(%{
          id: "id",
          destination_id: 1,
          name: "name",
          location: %{lat: 0.0, lng: 0.0, address: "address", city: "city", country: "country"},
          description: "description",
          amenities: [%{type: "type", amenity: "amenity"}],
          images: [%{type: "type", link: "link", description: "description"}],
          booking_conditions: [%{booking_condition: "booking_condition"}]
        })

      response =
        conn
        |> get(Routes.hotel_path(conn, :index))
        |> json_response(200)

      expected = [
        %{
          "id" => hotel.id,
          "destination_id" => hotel.destination_id,
          "name" => hotel.name,
          "location" => %{
            "lat" => Decimal.to_float(hotel.location.lat),
            "lng" => Decimal.to_float(hotel.location.lng),
            "address" => hotel.location.address,
            "city" => hotel.location.city,
            "country" => hotel.location.country
          },
          "description" => hotel.description,
          "amenities" => Enum.group_by(hotel.amenities, & &1.type, & &1.amenity),
          "images" =>
            Enum.group_by(
              hotel.images,
              & &1.type,
              &%{"link" => &1.link, "description" => &1.description}
            ),
          "booking_conditions" => Enum.map(hotel.booking_conditions, & &1.booking_condition)
        }
      ]

      assert response == expected
    end

    test "hotels query param responds with hotels with given ids", %{conn: conn} do
      _ = create_hotels()

      response =
        conn
        |> get(Routes.hotel_path(conn, :index), hotels: ["id0", "id1"])
        |> json_response(200)

      assert [%{"id" => "id0"}, %{"id" => "id1"}] = response
    end

    test "destination query param responds with hotels with given destination_ids", %{conn: conn} do
      _ = create_hotels()

      response =
        conn
        |> get(Routes.hotel_path(conn, :index), destination: 1)
        |> json_response(200)

      assert [%{"id" => "id0"}, %{"id" => "id2"}] = response
    end

    defp create_hotels do
      {:ok, h0} =
        Hotels.create_hotel(%{
          id: "id0",
          destination_id: 1,
          name: "name",
          location: %{lat: 0.0, lng: 0.0, address: "address", city: "city", country: "country"},
          description: "description",
          amenities: [],
          images: [%{type: "type", link: "link", description: "description"}],
          booking_conditions: [%{booking_condition: "booking_condition"}]
        })

      {:ok, h1} =
        Hotels.create_hotel(%{
          id: "id1",
          destination_id: 2,
          name: "name",
          location: %{lat: 0.0, lng: 0.0, address: "address", city: "city", country: "country"},
          description: "description",
          amenities: [],
          images: [%{type: "type", link: "link", description: "description"}],
          booking_conditions: [%{booking_condition: "booking_condition"}]
        })

      {:ok, h2} =
        Hotels.create_hotel(%{
          id: "id2",
          destination_id: 1,
          name: "name",
          location: %{lat: 0.0, lng: 0.0, address: "address", city: "city", country: "country"},
          description: "description",
          amenities: [],
          images: [%{type: "type", link: "link", description: "description"}],
          booking_conditions: [%{booking_condition: "booking_condition"}]
        })

      [h0, h1, h2]
    end
  end
end
