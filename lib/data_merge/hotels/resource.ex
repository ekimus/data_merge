defmodule DataMerge.Hotels.Resource do
  @moduledoc """
  Resource for hotel data.
  """

  def get(%{uri: uri, normaliser: normaliser}) do
    case URI.parse(uri) do
      %URI{scheme: "http"} ->
        get(uri, normaliser, [])

      %URI{scheme: "https"} ->
        get(uri, normaliser, transport_opts: [ciphers: :ssl.cipher_suites(:default, :"tlsv1.2")])
    end
  end

  defp get(uri, normaliser, opts) do
    with {:ok, %Mojito.Response{body: body}} <- Mojito.get(uri, [], opts),
         {:ok, data} <-
           Jason.decode(body) do
      {:ok, Enum.map(data, &normaliser.normalise/1)}
    else
      {:error, %Mojito.Error{} = reason} -> {:error, %{uri: uri, reason: reason}}
    end
  end
end
