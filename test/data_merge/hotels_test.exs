defmodule DataMerge.HotelsTest do
  @moduledoc false

  use DataMerge.DataCase, async: true

  alias DataMerge.Hotels
  alias DataMerge.Hotels.Hotel

  @attrs %{
    id: "id",
    destination_id: 1,
    name: "name",
    description: "description",
    amenities: [%{type: "type", amenity: "amenity"}],
    images: [%{type: "type", link: "link", description: "description"}],
    booking_conditions: [%{booking_condition: "booking_condition"}]
  }

  describe "create_hotel/1" do
    test "creates a hotel" do
      assert {:ok, %Hotel{}} = Hotels.create_hotel(@attrs)
    end
  end

  describe "list_hotels/0" do
    test "returns a list of hotels" do
      {:ok, hotel} = Hotels.create_hotel(@attrs)
      actual = Hotels.list_hotels()
      assert [hotel] == actual
    end
  end
end
