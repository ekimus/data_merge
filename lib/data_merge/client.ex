defmodule DataMerge.Client do
  def normalise_gdmqa(%{} = src) do
    %{
      id: src["Id"],
      destination_id: src["DestinationId"],
      name: src["Name"],
      location: %{
        lat: src["Latitude"],
        lng: src["Longitude"],
        address:
          [src["Address"], src["PostalCode"]]
          |> Enum.reject(&is_nil/1)
          |> Enum.map(&String.trim/1)
          |> Enum.join(", ")
          |> (&if(&1 == "", do: nil, else: &1)).(),
        city: src["City"],
        country: src["Country"]
      },
      description: fmap(src["Description"], &String.trim/1),
      amenities:
        src
        |> Map.get("Facilities", [])
        |> Enum.map(&%{type: "general", amenity: &1 |> String.trim() |> String.downcase()}),
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
        lat: nil,
        lng: nil,
        address: fmap(src["location"]["address"], &String.trim/1),
        city: nil,
        country: src["location"]["country"]
      },
      description: fmap(src["details"], &String.trim/1),
      amenities:
        src
        |> Map.get("amenities", %{})
        |> Map.to_list()
        |> Enum.flat_map(fn {k, v} ->
          Enum.map(v, &%{type: k, amenity: &1 |> String.trim() |> String.downcase()})
        end),
      images:
        src
        |> Map.get("images", %{})
        |> Map.to_list()
        |> Enum.flat_map(fn {k, v} ->
          Enum.map(v, &%{type: k, link: &1["link"], description: &1["caption"]})
        end),
      booking_conditions: Map.get(src, "booking_conditions", [])
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
        address: fmap(src["address"], &String.trim/1),
        city: nil,
        country: nil
      },
      description: fmap(src["info"], &String.trim/1),
      amenities:
        src
        |> Map.get("amenities", [])
        |> Enum.map(&%{type: "room", amenity: &1 |> String.trim() |> String.downcase()}),
      images:
        src
        |> Map.get("images", %{})
        |> Map.to_list()
        |> Enum.flat_map(fn {k, v} ->
          Enum.map(v, &%{type: k, link: &1["url"], description: &1["description"]})
        end),
      booking_conditions: []
    }
  end

  def reducer(%{} = a, %{} = b), do: Map.merge(a, b, &merger/3)

  defp merger(:amenities, a, b) do
    (a ++ b)
    |> Enum.group_by(& &1.type, & &1.amenity)
    |> Map.to_list()
    |> Enum.flat_map(fn {k, v} ->
      v
      |> Enum.sort()
      |> Enum.uniq()
      |> Enum.map(&%{type: k, amenity: &1})
    end)
  end

  defp merger(:images, a, b) do
    (a ++ b)
    |> Enum.group_by(& &1.type, &%{link: &1.link, description: &1.description})
    |> Map.to_list()
    |> Enum.flat_map(fn {k, v} ->
      v
      |> Enum.sort()
      |> Enum.uniq()
      |> Enum.map(&%{type: k, link: &1.link, description: &1.description})
    end)
  end

  defp merger(:booking_conditions, a, b), do: (a ++ b) |> Enum.sort() |> Enum.uniq()
  defp merger(:location, a, b), do: Map.merge(a, b, &merger/3)
  defp merger(_, nil, b), do: b
  defp merger(_, a, nil), do: a
  defp merger(_, _, b), do: b

  defp fmap(nil, _), do: nil
  defp fmap(x, f), do: apply(f, [x])
end
