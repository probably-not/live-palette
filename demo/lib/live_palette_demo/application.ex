defmodule LivePaletteDemo.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Phoenix.PubSub, name: LivePaletteDemo.PubSub},
      LivePaletteDemoWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: LivePaletteDemo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    LivePaletteDemoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
