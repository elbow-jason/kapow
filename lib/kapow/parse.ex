defmodule Kapow.Parse do

  def text(txt) do
    txt
    |> String.strip
    |> single_spaces
    |> String.split
    |> Enum.map(fn item -> parse item end)
  end

  def parse(item) do
    import Kapow.Matches
    cond do
      component?(item) ->
        capture(named_component, item)
      open_equals?(item) ->
        :open_equals
      open_brackets?(item) ->
        :open_brackets
      close_brackets?(item) ->
        :close_brackets
      true -> item
    end
  end

  def single_spaces(str) when str |> is_binary do
    str
    |> String.split("")
    |> Enum.reverse
    |> single_spaces([])
    |> Enum.join
  end
  def single_spaces([ " ", " " | rest ], acc) do
    single_spaces([ " " | rest ], acc)
  end
  def single_spaces([ " " | rest ], acc) do
    single_spaces(rest, [ " " | acc])
  end
  def single_spaces([ "" | rest], acc) do
    single_spaces(rest, acc)
  end
  def single_spaces([ first | rest ], acc) do
    single_spaces(rest, [ first | acc ])
  end
  def single_spaces([], acc) do
    acc
  end



end
