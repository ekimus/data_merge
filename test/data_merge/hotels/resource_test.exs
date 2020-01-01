defmodule DataMerge.ResourceTest do
  @moduledoc false
  use DataMerge.DataCase, async: true

  alias DataMerge.Hotels.Hotel
  alias DataMerge.Hotels.Normaliser.First
  alias DataMerge.Hotels.Resource

  describe "get/2" do
    test "returns normalised data" do
      assert {:ok, [%Hotel{id: "iJhz"}, %Hotel{id: "SjyX"}, %Hotel{id: "f8c9"}]} =
               Resource.get(%Resource{uri: "http://localhost:4001/gdmqa", normaliser: First})
    end
  end
end
