defmodule DataMerge.Hotels.Hotel.ImageTest do
  @moduledoc false
  use DataMerge.DataCase, async: true

  alias DataMerge.Hotels.Hotel.Image

  describe("changeset/2") do
    @valid_attrs %{type: "type", link: "link", description: "description"}

    test "valid fields" do
      changeset = Image.changeset(%Image{}, @valid_attrs)
      assert changeset.valid?
    end

    test "required fields" do
      changeset = Image.changeset(%Image{}, %{})

      assert %{
               type: ["can't be blank"],
               link: ["can't be blank"],
               description: ["can't be blank"]
             } = errors_on(changeset)
    end
  end
end
