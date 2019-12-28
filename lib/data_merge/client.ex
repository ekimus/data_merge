defmodule DataMerge.Client do
  # data from https://api.myjson.com/bins/gdmqa
  def normalise_gdmqa(%{} = src) do
    %{
      id: src["Id"],
      destination_id: src["DestinationId"],
      name: src["Name"],
      location: %{
        lat: src["Latitude"],
        lng: src["Longitude"],
        address: [String.trim(src["Address"]), String.trim(src["PostalCode"])] |> Enum.join(", "),
        city: src["City"],
        country: src["Country"]
      },
      description: String.trim(src["Description"]),
      amenities:
        Enum.map(
          src["Facilities"],
          &%{type: "general", amenity: &1 |> String.trim() |> String.downcase()}
        ),
      images: [],
      booking_conditions: []
    }
  end

  def normalise_1fva3m(%{} = src) do
    %{
      id: src["hotel_id"],
      destination_id: src["destination_id"],
      name: src["hotel_name"],
      location: %{
        address: String.trim(src["location"]["address"]),
        country: src["location"]["country"]
      },
      description: String.trim(src["details"]),
      amenities:
        src["amenities"]
        |> Map.to_list()
        |> Enum.flat_map(fn {k, v} ->
          Enum.map(v, &%{type: k, amenity: &1 |> String.trim() |> String.downcase()})
        end),
      images:
        src["images"]
        |> Map.to_list()
        |> Enum.flat_map(fn {k, v} ->
          Enum.map(v, &%{type: k, link: &1["link"], description: &1["caption"]})
        end),
      booking_conditions: src["booking_conditions"]
    }
  end

  def normalise_j6kzm(%{} = src) do
    %{
      id: src["id"],
      destination_id: src["destination"],
      name: src["name"],
      location: %{
        lat: src["lat"],
        lng: src["lng"],
        address: String.trim(src["address"])
      },
      description: String.trim(src["info"]),
      amenities:
        Enum.map(
          src["amenities"],
          &%{type: "room", amenity: &1 |> String.trim() |> String.downcase()}
        ),
      images:
        src["images"]
        |> Map.to_list()
        |> Enum.flat_map(fn {k, v} ->
          Enum.map(v, &%{type: k, link: &1["url"], description: &1["description"]})
        end),
      booking_conditions: []
    }
  end
end
