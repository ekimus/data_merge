defmodule DataMerge.Hotels.MergerTest do
  use ExUnit.Case, async: true

  alias DataMerge.Hotels.Hotel
  alias DataMerge.Hotels.Merger
  alias DataMerge.Hotels.Normaliser.First
  alias DataMerge.Hotels.Normaliser.Second
  alias DataMerge.Hotels.Normaliser.Third
  alias DataMerge.Hotels.Resource

  describe "merge/1" do
    test "merges resources" do
      resources = [
        %Resource{uri: "http://localhost:4001/gdmqa", normaliser: First},
        %Resource{uri: "http://localhost:4001/1fva3m", normaliser: Second},
        %Resource{uri: "http://localhost:4001/j6kzm", normaliser: Third}
      ]

      assert [
               %Hotel{id: "SjyX"},
               %Hotel{id: "f8c9"},
               %Hotel{id: "iJhz"}
             ] = Merger.merge(resources)
    end
  end
end
