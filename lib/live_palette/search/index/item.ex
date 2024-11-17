defmodule LivePalette.Search.Index.Item do
  @moduledoc false

  alias __MODULE__
  alias LivePalette.{Action, Actionable}
  alias LivePalette.Search.Index.PreprocessedAction

  @type id() :: non_neg_integer()

  @type t() :: %__MODULE__{
          id: id(),
          original: Actionable.t(),
          action: Action.t(),
          preprocessed: PreprocessedAction.t(),
          always_show?: boolean()
        }

  @enforce_keys [:id]
  defstruct [:id, :original, :action, :preprocessed, :always_show?]

  @spec build(actionable :: Actionable.t()) :: Item.t()
  def build(actionable) do
    action = LivePalette.Actionable.to_action(actionable)

    %Item{
      id: :erlang.phash2(actionable),
      original: actionable,
      action: action,
      preprocessed: PreprocessedAction.from_action(action),
      always_show?: action.always_show?
    }
  end

  @spec match_and_score(
          item :: Item.t(),
          query :: String.t(),
          threshold :: float()
        ) :: float() | :nomatch
  def match_and_score(%Item{} = item, query, threshold) do
    normalized_query = String.downcase(query)

    score =
      item.preprocessed
      |> PreprocessedAction.matches(normalized_query)
      |> Enum.max(&>=/2, fn -> 0 end)

    cond do
      score >= threshold -> score
      item.always_show? -> threshold
      true -> :nomatch
    end
  end
end
