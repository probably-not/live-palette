defmodule LivePalette.ComponentLive do
  @moduledoc false

  use Phoenix.LiveComponent
  import LivePalette.{Form, Result}
  alias Phoenix.LiveView.JS

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
    ## For animation purposes - this div does not have the "hidden" class set on it.
    ## The `phx-remove` animation will not be seen if the parent (this div) has the
    ## "hidden" class on it (for good reason... it's hidden).
    ## While it is empty, meaning it takes up no space visually in the document, it is not
    ## explicitly "hidden"... I'm not sure if this is a huge problem or not. For now, and for
    ## the sake of "prettiness", I'll keep it like this. However, it should probably be looked at
    ## eventually, just to make sure that this isn't... a problem...
    ~H"""
    <div
      id={@id}
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
      id={@id}
      phx-target={@myself}
      phx-window-keyup="hide_palette"
      phx-key="Escape"
    >
      <div
        id={@id <> "-wrapper"}
        class="fixed flex items-start justify-center w-full inset-0 pt-[14vh] px-4 pb-4"
        phx-remove={JS.exec("phx-remove", to: "##{@id}-palette")}
      >
        <div
          id={@id <> "-palette"}
          phx-target={@myself}
          phx-mounted={
            JS.transition(
              {"ease-out duration-100", "scale-0", "scale-100"},
              time: 100
            )
          }
          phx-remove={
            JS.transition(
              {"ease-in duration-100", "scale-100", "scale-0"},
              time: 100
            )
          }
          phx-click-away="hide_palette"
          phx-target={@myself}
          class="max-w-[600px] w-full bg-white text-black rounded-lg overflow-hidden shadow-[0px_6px_20px_0px_rgba(0,0,0,0.2)] pointer-events-auto"
        >
          <.form
            for={@form}
            phx-target={@myself}
            phx-change="search"
            phx-throttle={500}
          >
            <.input field={@form[:search_text]} placeholder={@placeholder} />
          </.form>
          <.result_list :if={@results and @results != []} results={@results} />
        </div>
      </div>
    </div>
    """
  end
end
