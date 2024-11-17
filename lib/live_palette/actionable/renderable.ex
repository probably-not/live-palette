defprotocol LivePalette.Actionable.Renderable do
  @spec render(t(), Phoenix.LiveView.Socket.assigns()) :: Phoenix.LiveView.Rendered.t()
  def render(t, assigns)
end
