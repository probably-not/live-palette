defmodule LivePalette.Search.Index do
  @moduledoc false

  alias __MODULE__
  alias LivePalette.Search.Index.{Item, PreprocessedAction}

  @opaque t() :: %__MODULE__{
            items: list(Item.t()),
            always_shown: list(Item.t())
          }

  defstruct [:items, :always_shown]

  @spec build(actionables :: list(LivePalette.Actionable.t())) :: Index.t()
  def build(actionables) do
    items =
      Enum.map(actionables, fn actionable ->
        action = LivePalette.Actionable.to_action(actionable)

        %Item{
          original: actionable,
          action: action,
          preprocessed: PreprocessedAction.from_action(action),
          always_show?: action.always_show?
        }
      end)

    %Index{items: items, always_shown: Enum.filter(items, & &1.always_show?)}
  end

  @spec query(index :: Index.t(), query :: String.t(), threshold :: float()) ::
          list(Item.t())
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
