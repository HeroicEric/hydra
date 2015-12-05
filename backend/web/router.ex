defmodule Hydra.Router do
  use Hydra.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Hydra do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api", Hydra do
    pipe_through :api

    resources "messages", MessageController, only: [:index, :show, :create]
  end
end
