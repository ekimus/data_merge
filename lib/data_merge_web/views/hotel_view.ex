defmodule DataMergeWeb.HotelView do
  use DataMergeWeb, :view

  alias DataMerge.Hotels.Hotel

  def render("index.json", %{hotels: hotels}) do
    render_many(hotels, DataMergeWeb.HotelView, "hotel.json")
  end

  def render("hotel.json", %{hotel: %Hotel{} = hotel}) do
    %{
      id: hotel.id,
      destination_id: hotel.destination_id,
      name: hotel.name,
      description: hotel.description
    }
  end
end
