defmodule LivePalette.Action do
  @type t() :: %__MODULE__{
          title: String.t(),
          subtitle: String.t() | nil,
          always_show?: boolean()
        }
  defstruct [:title, :subtitle, :always_show?]
end
