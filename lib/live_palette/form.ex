defmodule LivePalette.Form do
  @moduledoc false

  alias Phoenix.LiveView.JS
  use Phoenix.Component

  attr :placeholder, :string, required: true

  attr :field, Phoenix.HTML.FormField,
    doc:
      "a form field struct retrieved from the form, for example: @form[:email]"

  def input(assigns) do
    ~H"""
    <input
      phx-mounted={JS.focus()}
      type="text"
      name={@field.name}
      id={@field.id}
      value={@field.value}
      placeholder={@placeholder}
      autoFocus
      autoComplete="off"
      role="combobox"
      spellCheck="false"
      class="p-3 px-4 text-base w-full box-border outline-none border-none bg-white text-black"
    />
    """
  end
end
