defmodule LivePaletteDemoWeb.HomeLive do
  use LivePaletteDemoWeb, :live_view

  import LivePalette

  def mount(_params, _session, socket) do
    actions = [
      %{
        title: "Do something",
        always_show?: true,
        icon_name: "hero-home-modern"
      },
      %{
        title: "Do something else",
        subtitle: "This does something else",
        always_show?: true
      },
      %{
        title: "Do something other than those 2",
        always_show?: false
      }
    ]

    {:ok, assign(socket, actions: actions)}
  end

  def render(assigns) do
    ~H"""
    <h1>Hello World</h1>
    <.live_palette id="example" require_metakey={true} actions={@actions} />
    """
  end
end
