defmodule DataMerge.HotelControllerTest do
  use DataMergeWeb.ConnCase, async: true

  alias DataMerge.Hotels

  test "index/2 responds with all hotels", %{conn: conn} do
    {:ok, hotel} =
      Hotels.create_hotel(%{
        id: "id",
        destination_id: 1,
        name: "name",
        description: "description",
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
        "description" => hotel.description,
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
end
