defmodule DataMergeWeb.HotelController do
  use DataMergeWeb, :controller

  alias DataMerge.Hotels

  def index(conn, _params) do
    render(conn, "index.json", hotels: Hotels.list_hotels())
  end
end
