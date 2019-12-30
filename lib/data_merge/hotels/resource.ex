defmodule DataMerge.Hotels.Resource do
  @moduledoc """
  Resource for hotel data.
  """

  defstruct uri: "", normaliser: nil

  def get(%DataMerge.Hotels.Resource{uri: uri, normaliser: normaliser}) do
    with {:ok, %Mojito.Response{body: body}} <- Mojito.get(uri),
         {:ok, data} <- Jason.decode(body),
         do: {:ok, Enum.map(data, &normaliser.normalise/1)}
  end
end
