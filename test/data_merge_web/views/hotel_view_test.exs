defmodule DataMergeWeb.HotelViewTest do
  use DataMergeWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  setup [:create_hotel]

  @expected %{
    description: "description",
    destination_id: 1,
    id: "id",
    name: "name",
    amenities: %{type: ["amenity"]},
    images: %{type: [%{link: "link", description: "description"}]},
    booking_conditions: ["booking_condition"]
  }

  test "renders index.json", %{hotel: hotel} do
    assert render(DataMergeWeb.HotelView, "index.json", hotels: [hotel]) == [@expected]
  end

  test "renders hotel.json", %{hotel: hotel} do
    assert render(DataMergeWeb.HotelView, "hotel.json", hotel: hotel) == @expected
  end

  defp create_hotel(_context) do
    attrs = %{
      id: "id",
      destination_id: 1,
      name: "name",
      description: "description",
      amenities: [%{type: "type", amenity: "amenity"}],
      images: [%{type: "type", link: "link", description: "description"}],
      booking_conditions: [%{booking_condition: "booking_condition"}]
    }

    {:ok, hotel} = DataMerge.Hotels.create_hotel(attrs)
    [hotel: hotel]
  end
end
