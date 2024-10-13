defmodule LivePalette do
  @moduledoc """
  `LivePalette` is a component for `Phoenix.LiveView` that allows the user to implement a command palette,
  reminiscent of the VSCode and Sublime Command Palettes, the macOS Spotlight and Alfred, and Linear's Command-K Command Bar.
  """
  use Phoenix.Component

  require Logger

  attr :id, :string,
    required: true,
    doc: """
    The component ID. The underlying implementation of the LivePalette component is a LiveComponent, which requires a component ID.
    """

  attr :show_on_initial_render, :boolean,
    required: false,
    default: false,
    doc: """
    Whether or not to show the palette on the initial render. The LivePalette is a LiveComponent,
    so this property once set is then owned by the component itself, meaning that it should only be set once (on render),
    and subsequently left to the component to decide when to show or hide.
    This is by default set to false, however, in cases such as a reconnect or a refresh,
    when one might want to ensure that the user receives the same view that they had previously,
    this can be set to true to show it on the initial render.
    """

  attr :key, :string,
    required: false,
    default: "K",
    doc: "The key that should trigger showing the palette. This defaults to K."

  attr :require_metakey, :boolean,
    required: false,
    default: false,
    doc: """
    Whether or not the key should be pressed with the meta key. An explanation of how to enable the metadata that includes
    whether the meta key was pressed can be found on the [Phoenix LiveView Key Events documentation](https://hexdocs.pm/phoenix_live_view/bindings.html#key-events).
    If set to true, this will expect that you have enabled this metadata on your socket, and it will only match and toggle
    the palette when both the given key and the meta key are pressed together.
    """

  @doc """
  The live palette component itself.

  [INSERT LVATTRDOCS]
  """
  def live_palette(assigns) do
    ~H"""
    <.live_component
      module={LivePalette.ComponentLive}
      id={@id}
      show={@show_on_initial_render}
      key={@key}
      require_metakey={@require_metakey}
    />
    """
  end
end
