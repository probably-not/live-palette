defmodule LivePaletteDemoWeb.RenderedAction do
  @enforce_keys [:title, :subtitle, :icon_name, :always_show?]
  defstruct [:title, :subtitle, :icon_name, :always_show?]
end

defimpl LivePalette.Actionable, for: LivePaletteDemoWeb.RenderedAction do
  def to_action(%LivePaletteDemoWeb.RenderedAction{} = action) do
    %LivePalette.Action{
      title: action.title,
      subtitle: action.subtitle,
      always_show?: action.always_show?,
      icon_name: action.icon_name
    }
  end
end

defimpl LivePalette.Actionable.Renderable, for: LivePaletteDemoWeb.RenderedAction do
  use LivePaletteDemoWeb, :html

  def render(%LivePaletteDemoWeb.RenderedAction{} = action, assigns) do
    assigns =
      assigns
      |> assign(:action_title, action.title)
      |> assign(:action_subtitle, action.subtitle)

    ~H"""
    <.modal id="example-rendered-modal" show={true}>
      <h1><%= @action_title %></h1>
      <p><%= @action_subtitle %></p>
    </.modal>
    """
  end
end
