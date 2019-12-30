defmodule DataMerge.ResourceTest do
  @moduledoc false
  use ExUnit.Case, async: true
  alias DataMerge.Hotels.Resource
  alias DataMerge.Hotels.Hotel
  alias DataMerge.Hotels.Normaliser.First

  describe "get/2" do
    test "returns normalised data" do
      assert {:ok, [%Hotel{id: "iJhz"}, %Hotel{id: "SjyX"}, %Hotel{id: "f8c9"}]} =
               Resource.get(%Resource{uri: "http://localhost:4001/gdmqa", normaliser: First})
    end
  end
end
