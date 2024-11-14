defmodule LivePalette.Result do
  @moduledoc false

  use Phoenix.Component

  attr :results, :list, required: false, default: []

  # TODO: When upgrading to latest LV - we can set the type to be a function with an arity of 1.
  attr :icon_component, :any, required: true

  def result_list(assigns) do
    ~H"""
    <div class="max-h-[400px] relative overflow-auto">
      <div role="listbox" class="h-[478px] w-full">
        <.result
          :for={result <- @results}
          title={result.title}
          subtitle={result.subtitle}
          icon_component={@icon_component}
          icon_name={result.icon_name}
        />
      </div>
    </div>
    """
  end

  attr :title, :string, required: true
  attr :subtitle, :string, required: false
  attr :icon_name, :string, required: false

  # TODO: When upgrading to latest LV - we can set the type to be a function with an arity of 1.
  attr :icon_component, :any, required: true

  defp result(assigns) do
    ~H"""
    <div role="option">
      <div class="p-3 px-4 bg-transparent hover:bg-black/5 border-l-2 border-transparent hover:border-solid hover:border-black flex items-center justify-between cursor-pointer">
        <div class="flex gap-2 items-center text-sm">
          <%= if @icon_name do %>
            <%= @icon_component.(%{name: @icon_name, class: "h-6 w-6"}) %>
          <% end %>
          <div class="flex flex-col">
            <div><span><%= @title %></span></div>
            <span :if={@subtitle} class="text-xs"><%= @subtitle %></span>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
