defmodule DataMerge.Client do
  @moduledoc """
  Resource supplier client.
  """

  def get(uri, normaliser) do
    with {:ok, %Mojito.Response{body: body}} <- Mojito.get(uri),
         {:ok, data} <- Jason.decode(body),
         do: {:ok, Enum.map(data, &normaliser.normalise/1)}
  end
end
