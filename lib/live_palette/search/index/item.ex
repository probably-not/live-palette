defmodule LivePalette.Search.Index.Item do
  @moduledoc false

  alias __MODULE__
  alias LivePalette.{Action, Actionable}
  alias LivePalette.Search.Index.PreprocessedAction

  @type t() :: %__MODULE__{
          original: Actionable.t(),
          action: Action.t(),
          preprocessed: PreprocessedAction.t(),
          always_show?: boolean()
        }

  defstruct [:original, :action, :preprocessed, :always_show?]

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
