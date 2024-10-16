defmodule LivePalette.Result do
  use Phoenix.Component

  def result_list(assigns) do
    ~H"""
    <div class="max-h-[400px] relative overflow-auto">
      <div role="listbox" class="h-[478px] w-full">
        <.result />
      </div>
    </div>
    """
  end

  defp result(assigns) do
    ~H"""
    """
  end
end
