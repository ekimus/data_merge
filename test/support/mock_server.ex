defmodule DataMerge.MockServer do
  @moduledoc """
  Mock server for testing.
  """
  use Plug.Builder

  plug Plug.Static, at: "/", from: "test/data"
  plug :not_found

  def not_found(conn, _options) do
    send_resp(conn, 404, "not found")
  end
end
