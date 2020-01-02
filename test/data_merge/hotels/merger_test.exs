defmodule DataMerge.Hotels.MergerTest do
  use DataMerge.DataCase, async: false

  alias DataMerge.Hotels
  alias DataMerge.Hotels.Hotel
  alias DataMerge.Hotels.Merger
  alias DataMerge.Hotels.Normaliser.First
  alias DataMerge.Hotels.Normaliser.Second
  alias DataMerge.Hotels.Normaliser.Third
  alias DataMerge.Hotels.Resource

  @resources [
    %Resource{uri: "http://localhost:4001/gdmqa", normaliser: First},
    %Resource{uri: "http://localhost:4001/1fva3m", normaliser: Second},
    %Resource{uri: "http://localhost:4001/j6kzm", normaliser: Third}
  ]

  describe "merge/1" do
    test "merges resources and saves to database" do
      Merger.merge(@resources)
      assert [%Hotel{id: "SjyX"}, %Hotel{id: "f8c9"}, %Hotel{id: "iJhz"}] = Hotels.list_hotels()
    end
  end
end
