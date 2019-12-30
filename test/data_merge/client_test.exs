defmodule DataMerge.ClientTest do
  @moduledoc false
  use ExUnit.Case, async: true
  alias DataMerge.Client
  alias DataMerge.Hotels.Hotel
  alias DataMerge.Hotels.Normaliser.First

  describe "get/2" do
    test "returns normalised data" do
      assert {:ok, [%Hotel{id: "iJhz"}, %Hotel{id: "SjyX"}, %Hotel{id: "f8c9"}]} =
               Client.get("http://localhost:4001/gdmqa", First)
    end
  end
end
