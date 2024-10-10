defmodule LivePaletteDemoWeb.Router do
  use LivePaletteDemoWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {LivePaletteDemoWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LivePaletteDemoWeb do
    pipe_through :browser

    live "/", HomeLive, :home
  end
end
