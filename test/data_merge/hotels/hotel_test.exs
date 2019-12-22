defmodule DataMerge.Hotels.HotelTest do
  @moduledoc false

  use DataMerge.DataCase, async: true

  alias DataMerge.Hotels.Hotel

  describe "changeset/2" do
    @valid_attrs %{
      id: "id",
      destination_id: 1,
      name: "name",
      description: "description",
      booking_conditions: [%{booking_condition: "booking_condition"}]
    }

    test "valid fields" do
      changeset = Hotel.changeset(%Hotel{}, @valid_attrs)
      assert changeset.valid?
    end

    test "required fields" do
      changeset = Hotel.changeset(%Hotel{}, %{})

      assert %{
               id: ["can't be blank"],
               destination_id: ["can't be blank"],
               name: ["can't be blank"],
               description: ["can't be blank"],
               booking_conditions: ["can't be blank"]
             } = errors_on(changeset)
    end
  end
end
