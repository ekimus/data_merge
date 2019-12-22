defmodule DataMerge.Hotels.Hotel.BookingConditionTest do
  @moduledoc false

  use DataMerge.DataCase, async: true

  alias DataMerge.Hotels.Hotel.BookingCondition

  describe("changeset/2") do
    @valid_attrs %{booking_condition: "booking_condition"}

    test "valid fields" do
      changeset = BookingCondition.changeset(%BookingCondition{}, @valid_attrs)
      assert changeset.valid?
    end

    test "required fields" do
      changeset = BookingCondition.changeset(%BookingCondition{}, %{})
      assert %{booking_condition: ["can't be blank"]} = errors_on(changeset)
    end
  end
end
