defmodule DataMerge.UtilsTest do
  use ExUnit.Case, async: true
  alias DataMerge.Utils

  describe "fmap/2" do
    test "returns nil for nil x" do
      assert nil == Utils.fmap(nil, &String.trim/1)
    end

    test "returns f(x) for some x" do
      assert "foo" = Utils.fmap(" foo ", &String.trim/1)
    end
  end

  describe "normalise/1" do
    test "trims leading and trailing whitespace and converts string to lowercase" do
      assert "foo" = Utils.normalise(" FoO ")
    end
  end

  describe "substitutions/2" do
    test "substitues values in list with values matched by map key" do
      assert ["foo", "bar"] = Utils.substitutions(["foo", "baz"], %{"baz" => "bar"})
    end
  end
end
