defmodule LivePaletteDemoWeb.HomeLive do
  use LivePaletteDemoWeb, :live_view

  import LivePalette

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Hello World</h1>
    <.live_palette id="1" require_metakey={true} />
    """
  end
end
