defmodule DataMerge.HotelsTest do
  @moduledoc false

  use DataMerge.DataCase, async: true

  alias DataMerge.Hotels
  alias DataMerge.Hotels.Hotel

  @attrs %{
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
    images: [%{type: "type", link: "link", description: "description"}],
    booking_conditions: [%{booking_condition: "booking_condition"}]
  }

  describe "create_hotel/1" do
    test "creates a hotel" do
      assert {:ok, %Hotel{}} = Hotels.create_hotel(@attrs)
    end
  end

  describe "update_hotel/2" do
    test "updates a hotel" do
      {:ok, hotel} = Hotels.create_hotel(@attrs)

      assert {:ok, %Hotel{name: "new name"}} =
               Hotels.update_hotel(hotel, %{@attrs | name: "new name"})
    end
  end

  describe "list_hotels/0" do
    test "returns a list of hotels" do
      {:ok, hotel} = Hotels.create_hotel(@attrs)
      actual = Hotels.list_hotels()
      assert [hotel] == actual
    end
  end

  describe "hotels/1" do
    setup [:create_hotels]

    test "returns hotels with the given ids", %{hotels: hotels} do
      xs = ["id0", "id1"]
      expected = Enum.filter(hotels, &(&1.id in xs))
      actual = Hotels.hotels(xs)
      assert Enum.all?(expected, &(&1 in actual))
    end
  end

  describe "destination/1" do
    setup [:create_hotels]

    test "returns hotels with the given destination_id", %{hotels: hotels} do
      expected = Enum.filter(hotels, &(&1.destination_id == 1))
      actual = Hotels.destination(1)
      assert Enum.all?(expected, &(&1 in actual))
    end
  end

  describe "get_hotel/1" do
    test "returns a hotel with the given id" do
      {:ok, hotel} = Hotels.create_hotel(@attrs)
      actual = Hotels.get_hotel(hotel.id)
      assert hotel == actual
    end
  end

  describe "amenities/1" do
    test "returns list of matching, nearly matching, and unmatched amenities" do
      assert {[%{amenity: "outdoor pool"}], [%{amenity: "business center"}], ["unmatched"]} =
               Hotels.amenities(["outdoor pool", "businesscenter", "unmatched"])
    end
  end

  defp create_hotels(_) do
    {:ok, h0} = Hotels.create_hotel(%{@attrs | destination_id: 0})
    {:ok, h1} = Hotels.create_hotel(%{@attrs | id: "id0"})
    {:ok, h2} = Hotels.create_hotel(%{@attrs | id: "id1"})

    [hotels: [h0, h1, h2]]
  end
end
