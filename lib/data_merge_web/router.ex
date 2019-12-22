defmodule DataMergeWeb.Router do
  use DataMergeWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DataMergeWeb do
    pipe_through :api

    get "/", HotelController, :index
  end
end
