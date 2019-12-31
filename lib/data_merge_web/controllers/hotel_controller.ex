defmodule DataMergeWeb.HotelController do
  use DataMergeWeb, :controller

  alias DataMerge.Hotels

  def index(conn, %{"destination" => destination_id}),
    do: render(conn, "index.json", hotels: Hotels.destination(destination_id))

  def index(conn, %{"hotels" => ids}), do: render(conn, "index.json", hotels: Hotels.hotels(ids))
  def index(conn, _params), do: render(conn, "index.json", hotels: Hotels.list_hotels())
end
