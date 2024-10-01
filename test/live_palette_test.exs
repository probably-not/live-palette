defmodule LivePaletteTest do
  use ExUnit.Case
  doctest LivePalette

  test "code loaded" do
    assert Code.loaded?(LivePalette)
  end
end
