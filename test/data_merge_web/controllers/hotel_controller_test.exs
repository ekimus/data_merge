defmodule DataMerge.HotelControllerTest do
  use DataMergeWeb.ConnCase, async: true

  alias DataMerge.Hotels

  test "index/2 responds with all hotels", %{conn: conn} do
    {:ok, hotel} =
      Hotels.create_hotel(%{id: "id", destination_id: 1, name: "name", description: "description"})

    response =
      conn
      |> get(Routes.hotel_path(conn, :index))
      |> json_response(200)

    expected = [
      %{
        "id" => hotel.id,
        "destination_id" => hotel.destination_id,
        "name" => hotel.name,
        "description" => hotel.description
      }
    ]

    assert response == expected
  end
end
