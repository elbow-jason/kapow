defmodule Kapow.Matches do

  def compile!(pattern) do
    pattern |> Regex.compile!
  end

  def matches?(pattern, string) do
    pattern
    |> compile!
    |> Regex.match?(string)
  end

  def capture(pattern, string) do
    pattern
    |> compile!
    |> Regex.named_captures(string)
  end

  def component?(string) do
    matches?(raw_component, string)
  end

  def open_equals?(string) do
    matches?(raw_open_equals, string)
  end

  def open_brackets?(string) do
    matches?(raw_open_brackets, string) and
    not matches?(raw_open_equals, string)
  end

  def close_brackets?(string) do
    matches?(raw_close_brackets, string)
  end

  def double_quote?(string) do
    matches?(raw_double_quote, string)
  end

  def raw_double_quote,       do: ~s(")
  def raw_component,          do: "<:[a-zA-Z_]+>"
  def raw_open_equals,        do: "^<%="
  def raw_open_brackets,      do: "^<%"
  def raw_close_brackets,     do: "%>$"

  def named_component,        do: "<:(?<component>[a-zA-Z_]+)>"


end
