defmodule LivePalette.Actionable.NotImplemented do
  alias __MODULE__
  defexception [:message]

  @impl true
  def exception(actionable) do
    msg = "the given Actionable.t() #{inspect(actionable)} does not implement an action for selection."
    %NotImplemented{message: msg}
  end
end
