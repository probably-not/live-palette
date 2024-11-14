defprotocol LivePalette.Actionable do
  @spec to_action(t()) :: LivePalette.Action.t()
  def to_action(t)
end
