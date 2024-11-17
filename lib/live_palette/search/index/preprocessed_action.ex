defmodule LivePalette.Search.Index.PreprocessedAction do
  @moduledoc false

  alias __MODULE__

  @type t() :: %__MODULE__{
          title: String.t(),
          subtitle: String.t() | nil,
          acronym: String.t(),
          words: list(String.t())
        }

  defstruct [:title, :subtitle, :acronym, :words]

  @weights %{
    exact: 1.0,
    prefix: 0.9,
    acronym: 0.8,
    word_boundary: 0.7,
    substring: 0.6,
    fuzzy: 0.4
  }

  @spec from_action(action :: LivePalette.Action.t()) :: PreprocessedAction.t()
  def from_action(%LivePalette.Action{} = action) do
    %PreprocessedAction{
      title: normalize(action.title),
      subtitle: normalize(action.subtitle),
      acronym: acronym(action.title),
      words: words(action.title)
    }
  end

  # credo:disable-for-next-line
  # TODO: For now, I've implemented exact, prefix, acronym, and substring matching.
  # Other suggested match types are word boundary, and fuzzy matching.
  # I'm going to leave those off right now so I can continue with the next parts of the project,
  # but I should come back to this part so we can figure out a better way to do the matching in an efficient way.

  # credo:disable-for-next-line
  # TODO: This all needs to be tested and validated. Ideally as much as possible.

  @spec matches(action :: PreprocessedAction.t(), query :: String.t()) :: list(float())
  def matches(action, query)

  def matches(%PreprocessedAction{title: title}, title) do
    [weights().exact]
  end

  def matches(%PreprocessedAction{subtitle: subtitle}, subtitle) do
    [weights().exact * 0.9]
  end

  def matches(%PreprocessedAction{subtitle: nil} = action, query) do
    [
      prefix_match(action.title, query),
      acronym_match(action.acronym, query),
      substring_match(action.title, query)
    ]
    |> Enum.reject(&is_nil/1)
  end

  def matches(%PreprocessedAction{} = action, query) do
    title_scores = matches(%PreprocessedAction{action | subtitle: nil}, query)

    subtitle_scores =
      [
        prefix_match(action.subtitle, query),
        substring_match(action.title, query)
      ]
      |> Enum.reject(&is_nil/1)
      |> Enum.map(fn score -> score * 0.9 end)

    title_scores ++ subtitle_scores
  end

  defp prefix_match(value, query) do
    if String.starts_with?(value, query) do
      weights().prefix * (1 - byte_size(query) / byte_size(value) * 0.1)
    else
      nil
    end
  end

  defp acronym_match(acronym, query) do
    if String.starts_with?(acronym, query) do
      weights().acronym * (byte_size(query) / byte_size(acronym))
    else
      nil
    end
  end

  defp substring_match(value, query) do
    case :binary.match(value, query) do
      :nomatch -> nil
      {index, _match_length} -> weights().substring * (1 - index / byte_size(value) * 0.3)
    end
  end

  defp acronym(str) do
    str |> String.split() |> Enum.map_join(&String.first/1)
  end

  defp words(str) do
    str |> String.split() |> Enum.map(&normalize/1)
  end

  defp normalize(nil), do: nil
  defp normalize(""), do: nil
  defp normalize(s), do: s |> String.downcase() |> String.trim()

  defp weights, do: @weights
end
