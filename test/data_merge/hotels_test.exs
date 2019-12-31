defmodule DataMerge.HotelsTest do
  @moduledoc false

  use DataMerge.DataCase, async: true

  alias DataMerge.Hotels
  alias DataMerge.Hotels.Hotel

  @attrs %{
    id: "id",
    destination_id: 1,
    name: "name",
    location: %{lat: 0.0, lng: 0.0, address: "address", city: "city", country: "country"},
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

  describe "hotels/1" do
    setup [:create_hotels]

    test "returns hotels with the given ids", %{hotels: hotels} do
      xs = ["id0", "id1"]
      expected = Enum.filter(hotels, &(&1.id in xs))
      actual = Hotels.hotels(xs)
      assert Enum.reduce(actual, true, fn x, acc -> acc && x in expected end)
    end
  end

  describe "destination/1" do
    setup [:create_hotels]

    test "returns hotels with the given destination_id", %{hotels: hotels} do
      expected = Enum.filter(hotels, &(&1.destination_id == 1))
      actual = Hotels.destination(1)
      assert Enum.reduce(actual, true, fn x, acc -> acc && x in expected end)
    end
  end

  defp create_hotels(_) do
    {:ok, h0} = Hotels.create_hotel(%{@attrs | destination_id: 0})
    {:ok, h1} = Hotels.create_hotel(%{@attrs | id: "id0"})
    {:ok, h2} = Hotels.create_hotel(%{@attrs | id: "id1"})

    [hotels: [h0, h1, h2]]
  end
end
