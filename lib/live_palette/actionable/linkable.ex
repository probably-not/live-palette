defprotocol LivePalette.Actionable.Linkable do
  @spec link_to(t()) :: String.t()
  def link_to(t)
end
