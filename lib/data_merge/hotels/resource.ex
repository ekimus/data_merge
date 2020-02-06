defmodule DataMerge.Hotels.Resource do
  @moduledoc """
  Resource for hotel data.
  """

  defstruct normaliser: nil, uri: nil

  @type t :: %__MODULE__{normaliser: module(), uri: String.t()}

  @type error :: %{reason: term(), uri: String.t()}

  @spec get(resource :: t()) :: {:error, error()} | {:ok, [DataMerge.Hotels.Hotel.t()]}
  def get(resource) do
    opts =
      case URI.parse(resource.uri) do
        %URI{scheme: "http"} ->
          []

        %URI{scheme: "https"} ->
          [transport_opts: [ciphers: :ssl.cipher_suites(:default, :"tlsv1.2")]]
      end

    with {:ok, %Mojito.Response{body: body}} <- Mojito.get(resource.uri, [], opts),
         {:ok, data} <-
           Jason.decode(body) do
      {:ok, Enum.map(data, &resource.normaliser.normalise/1)}
    else
      {:error, reason} -> {:error, %{uri: resource.uri, reason: reason}}
    end
  end
end
