defmodule LivePaletteDemoWeb.GotoExternal do
  @enforce_keys [:title, :link]
  defstruct [:title, :subtitle, :link]
end

defimpl LivePalette.Actionable, for: LivePaletteDemoWeb.GotoExternal do
  def to_action(%LivePaletteDemoWeb.GotoExternal{} = goto) do
    %LivePalette.Action{
      title: goto.title,
      subtitle: goto.subtitle,
      always_show?: true,
      icon_name: "hero-arrow-top-right-on-square"
    }
  end
end

defimpl LivePalette.Actionable.ExternallyLinkable, for: LivePaletteDemoWeb.GotoExternal do
  def link_external(%LivePaletteDemoWeb.GotoExternal{} = goto), do: goto.link
end

defmodule LivePaletteDemoWeb.GotoInternal do
  @enforce_keys [:title, :link]
  defstruct [:title, :subtitle, :link]
end

defimpl LivePalette.Actionable, for: LivePaletteDemoWeb.GotoInternal do
  def to_action(%LivePaletteDemoWeb.GotoInternal{} = goto) do
    %LivePalette.Action{
      title: goto.title,
      subtitle: goto.subtitle,
      always_show?: false,
      icon_name: "hero-link"
    }
  end
end

defimpl LivePalette.Actionable.Linkable, for: LivePaletteDemoWeb.GotoInternal do
  def link_to(%LivePaletteDemoWeb.GotoInternal{} = goto), do: goto.link
end
