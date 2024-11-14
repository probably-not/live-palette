defmodule LivePalette.Action do
  @type t() :: %__MODULE__{
          title: String.t(),
          subtitle: String.t() | nil,
          always_show?: boolean(),
          icon_name: String.t() | nil
        }
  defstruct [:title, :subtitle, :always_show?, :icon_name]
end
