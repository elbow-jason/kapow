defmodule Kapow.Parse do

  def text(txt) do
    txt
    |> identify_strings
    |> Enum.map(fn
      {:code,     code} -> parse_brackets(code)
      {:string, string} -> {:string, string}
    end)
    |> List.flatten
  end

  def identify_strings(txt) do
    txt
    |> String.split(~s("))
    |> parse_strings([])
  end

  def parse_strings([code, string | rest], acc) do
    parse_strings(rest, [{:string, string}, {:code, code} | acc])
  end
  def parse_strings([code], acc) do
    [{:code, code} | acc] |> Enum.reverse
  end

  def parse_brackets(txt) when txt |> is_binary do
    txt
    |> String.strip
    |> single_spaces
    |> String.split
    |> Enum.map(fn item -> parse item end)
  end
  def parse_brackets(not_a_string) do
    not_a_string
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
