defmodule DataMerge.Hotels.Hotel.AmenityTest do
  @moduledoc false
  use DataMerge.DataCase, async: true

  alias DataMerge.Hotels.Hotel.Amenity

  describe("changeset/2") do
    @valid_attrs %{type: "type", amenity: "amenity"}

    test "valid fields" do
      changeset = Amenity.changeset(%Amenity{}, @valid_attrs)
      assert changeset.valid?
    end

    test "required fields" do
      changeset = Amenity.changeset(%Amenity{}, %{})

      assert %{
               type: ["can't be blank"],
               amenity: ["can't be blank"]
             } = errors_on(changeset)
    end
  end
end
