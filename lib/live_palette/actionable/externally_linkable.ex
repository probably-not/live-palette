defprotocol LivePalette.Actionable.ExternallyLinkable do
  @spec link_external(t()) :: String.t()
  def link_external(t)
end
