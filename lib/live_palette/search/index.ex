defmodule LivePalette.Search.Index do
  @moduledoc false

  alias __MODULE__
  alias LivePalette.Actionable
  alias LivePalette.Search.Index.Item

  @opaque t() :: %__MODULE__{
            items: list(Item.t()),
            always_shown: list(Item.t()),
            actionables: %{
              Index.Item.id() => Actionable.t()
            }
          }

  defstruct [:items, :always_shown, :actionables]

  @spec build(actionables :: list(LivePalette.Actionable.t())) :: Index.t()
  def build(actionables) do
    items = Enum.map(actionables, &Item.build/1)

    %Index{
      items: items,
      always_shown: Enum.filter(items, & &1.always_show?),
      actionables: Enum.reduce(items, %{}, fn item, acc -> Map.put(acc, item.id, item.original) end)
    }
  end

  @spec get_actionable!(index :: Index.t(), id :: Item.id()) :: Actionable.t() | no_return()
  def get_actionable!(%Index{} = index, id) do
    Map.fetch!(index.actionables, id)
  end

  @spec query(index :: Index.t(), query :: String.t(), threshold :: float()) :: list(Item.t())
  def query(index, query, threshold)

  def query(%Index{} = index, "", _threshold) do
    index.always_shown
  end

  def query(%Index{} = index, query, threshold) when is_binary(query) do
    Enum.reduce(index.items, [], fn %Item{} = item, acc ->
      case Item.match_and_score(item, query, threshold) do
        :nomatch -> acc
        score when is_float(score) -> [{score, item} | acc]
      end
    end)
    |> List.keysort(0, :desc)
    |> Enum.map(&elem(&1, 1))
  end
end
