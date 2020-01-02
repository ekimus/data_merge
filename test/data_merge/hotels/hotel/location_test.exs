defmodule DataMerge.Hotels.Hotel.LocationTest do
  @moduledoc false
  use DataMerge.DataCase, async: true

  alias DataMerge.Hotels.Hotel.Location

  describe("changeset/2") do
    @valid_attrs %{lat: 0.0, lng: 0.0, address: "address", city: "city", country: "country"}

    test "valid fields" do
      changeset = Location.changeset(%Location{}, @valid_attrs)
      assert changeset.valid?
    end
  end
end
