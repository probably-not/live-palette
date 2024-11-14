defmodule LivePalette.Search do
  @moduledoc false

  # TODO: This is a very basic search implementation that uses `String.jaro_distance/2`
  # in order to see whether we match. There's definitely better ways to determine matches,
  # for example, using Regex for matching, using exact matching, etc.
  # We should definitely build a much smarter scoring mechanism, although performance is a factor
  # here, it needs to run as the user types, so it cannot be a heavy operation.

  def matches(actions_list, term, threshold) do
    Enum.reduce(actions_list, [], fn %LivePalette.Action{} = action, acc ->
      with title_score <- String.jaro_distance(action.title, term),
           {:title, _title_score, false} <-
             {:title, title_score, title_score >= threshold},
           subtitle when not is_nil(subtitle) <- action.subtitle,
           subtitle_score <- String.jaro_distance(subtitle, term),
           {:subtitle, _subtitle_score, false} <-
             {:subtitle, subtitle_score, subtitle_score >= threshold},
           true <- action.always_show? do
        [{0.0, action} | acc]
      else
        {:title, title_score, true} ->
          [{title_score, action} | acc]

        {:subtitle, subtitle_score, true} ->
          [{subtitle_score, action} | acc]

        _ ->
          acc
      end
    end)
    |> List.keysort(0, :desc)
    |> Enum.map(&elem(&1, 1))
  end
end
