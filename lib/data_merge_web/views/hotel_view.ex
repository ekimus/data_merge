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
      description: hotel.description,
      location: %{
        lat: DataMerge.Utils.fmap(hotel.location.lat, &Decimal.to_float/1),
        lng: DataMerge.Utils.fmap(hotel.location.lng, &Decimal.to_float/1),
        address: hotel.location.address,
        city: hotel.location.city,
        country: hotel.location.country
      },
      amenities: Enum.group_by(hotel.amenities, &String.to_atom(&1.type), & &1.amenity),
      images:
        Enum.group_by(
          hotel.images,
          &String.to_atom(&1.type),
          &%{link: &1.link, description: &1.description}
        ),
      booking_conditions: Enum.map(hotel.booking_conditions, & &1.booking_condition)
    }
  end
end
