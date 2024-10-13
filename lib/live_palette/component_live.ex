defmodule LivePalette.ComponentLive do
  @moduledoc false

  use Phoenix.LiveComponent

  def mount(socket) do
    if connected?(socket) do
      {:ok, render_with(socket, &render/1)}
    else
      {:ok, render_with(socket, &disconnected_render/1)}
    end
  end

  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end

  def handle_event("show_palette", %{"key" => _key} = params, socket) do
    meta? = Map.get(params, socket.assigns.metakey_param, false)

    cond do
      socket.assigns.require_metakey and meta? ->
        {:noreply, assign(socket, show: true)}

      socket.assigns.require_metakey and not meta? ->
        {:noreply, socket}

      true ->
        {:noreply, assign(socket, show: true)}
    end
  end

  def handle_event("hide_palette", _params, socket) do
    {:noreply, assign(socket, show: false)}
  end

  def disconnected_render(assigns) do
    ~H"""
    <div></div>
    """
  end

  def render(%{show: false} = assigns) do
    ~H"""
    <div
      class="hidden"
      phx-target={@myself}
      phx-window-keydown="show_palette"
      phx-key={@key}
      phx-throttle={1000}
    >
    </div>
    """
  end

  def render(%{show: true} = assigns) do
    ~H"""
    <div
      phx-target={@myself}
      phx-window-keyup="hide_palette"
      phx-key="Escape"
      phx-click-away="hide_palette"
    >
      <h1>Wow I'm showing</h1>
    </div>
    """
  end
end
