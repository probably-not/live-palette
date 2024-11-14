defimpl LivePalette.Actionable, for: Map do
  def to_action(%{} = attrs) do
    %LivePalette.Action{
      title: attrs.title,
      subtitle: attrs[:subtitle],
      always_show?: attrs.always_show?
    }
  end
end