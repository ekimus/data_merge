defmodule DataMergeWeb.Router do
  use DataMergeWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", DataMergeWeb do
    pipe_through :api
  end
end
