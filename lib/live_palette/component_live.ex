defmodule LivePalette.ComponentLive do
  @moduledoc false

  use Phoenix.LiveComponent
  import LivePalette.{Form, Result}

  def mount(socket) do
    if connected?(socket) do
      {:ok, render_with(socket, &render/1)}
    else
      {:ok, render_with(socket, &disconnected_render/1)}
    end
  end

  def update(assigns, socket) do
    socket =
      assign(socket, assigns)
      |> assign_new(:form, fn -> to_form(%{"search_text" => ""}) end)
      |> assign_new(:results, fn -> nil end)

    {:ok, socket}
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

  def handle_event("search", %{"search_text" => search_text} = _params, socket) do
    {:noreply, assign(socket, :form, to_form(%{"search_text" => search_text}))}
  end

  def disconnected_render(assigns) do
    ~H"""
    <div class="hidden"></div>
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
    # TODO: Use phx-mounted and phx-remove in order to animate show and hide properly.
    ~H"""
    <div
      phx-target={@myself}
      phx-window-keyup="hide_palette"
      phx-key="Escape"
      phx-click-away="hide_palette"
    >
      <div class="fixed flex items-start justify-center w-full inset-0 pt-[14vh] px-4 pb-4">
        <div class="max-w-[600px] w-full bg-white text-black rounded-lg overflow-hidden shadow-[0px_6px_20px_0px_rgba(0,0,0,0.2)] pointer-events-auto">
          <.form
            for={@form}
            phx-target={@myself}
            phx-change="search"
            phx-throttle={500}
          >
            <.input field={@form[:search_text]} placeholder={@placeholder} />
          </.form>
          <.result_list :if={@results} results={@results} />
        </div>
      </div>
    </div>
    """
  end
end
