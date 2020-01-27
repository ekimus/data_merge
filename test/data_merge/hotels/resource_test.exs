defmodule DataMerge.ResourceTest do
  @moduledoc false
  use DataMerge.DataCase, async: true

  alias DataMerge.Hotels.Normaliser.First
  alias DataMerge.Hotels.Resource

  describe "get/2" do
    test "returns normalised data" do
      assert {:ok, [%{id: "iJhz"}, %{id: "SjyX"}, %{id: "f8c9"}]} =
               Resource.get(%{uri: "http://localhost:4001/gdmqa.json", normaliser: First})
    end
  end
end
