defmodule LivePalette.Action do
  @moduledoc """
  `LivePalette.Action` defines the action struct that is used internally in `LivePalette`.
  It contains details that allow us to render the action in the results list.
  """

  @typedoc """
  `LivePalette.Action` contains multiple fields that can be used to determine how to render an action in the `LivePalette`.

  `:title` and `:always_show?` are required when creating a `LivePalette.Action` - they determine what the action is called,
  and whether is is statically shown in all results all the time. Results that match will be shown before those that are defined
  with `:always_show?` set to `true`.
  """
  @type t() :: %__MODULE__{
          title: String.t(),
          always_show?: boolean(),
          subtitle: String.t() | nil,
          icon_name: String.t() | nil
        }
  @enforce_keys [:title, :always_show?]
  defstruct [:title, :subtitle, :always_show?, :icon_name]
end
