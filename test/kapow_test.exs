defmodule KapowTest do
  use ExUnit.Case, async: true

  test "the truth" do
    assert 1 + 1 == 2
  end

end


defmodule KapowParseTest do
  use ExUnit.Case, async: true
  alias Kapow.Parse, as: Parse

  test "Kapow.Parse.single_spaces removes duplicate spaces" do
    data = "Data       Melon         Rick JasonLouis"
    assert Parse.single_spaces(data) == "Data Melon Rick JasonLouis"
  end

  test "parse parses an item correctly" do
    assert Parse.parse("<:Body>") == %{"component" => "Body"}
    assert Parse.parse("<%=")     == :open_equals
    assert Parse.parse("<%")      == :open_brackets
    assert Parse.parse("%>")      == :close_brackets
    assert Parse.parse("% >")     == "% >"
    assert Parse.parse("<%  =")   == :open_brackets
    assert Parse.parse("<div>")   == "<div>"
  end

  test "text parses components, brackets, and content" do
    result =  Parse.text """
      <:Body>
        <%= IO.puts animal %>
    """
    expected = [
      %{"component" => "Body"},
      :open_equals,
      "IO.puts",
      "animal",
      :close_brackets,
    ]
    assert result == expected
  end

end


defmodule KapowMatchesTest do
  use ExUnit.Case, async: true
  alias Kapow.Matches, as: Matches

  test "Kapow.Matches.component matches components" do
    assert Matches.component? "<:Body> is a component!"
    assert Matches.component? "<:Kitten> is a component!"
    assert Matches.component? "<:Kitten>"
    assert Matches.component? "<:Kit_ten>"
    refute Matches.component? "<:Kitten"
    refute Matches.component? "Kitten>"
    refute Matches.component? "Kitten"
  end

  test "Kapow.Matches.open_brackets? matches '<%'" do
    assert Matches.open_brackets? "<% weeeeee }}"
    assert Matches.open_brackets? "<%"
    refute Matches.open_brackets? "< %"
    refute Matches.open_brackets? "<"
    refute Matches.open_brackets? " weeeeee "
  end

  test "Kapow.Matches.close_brackets? matches '%>'" do
    assert Matches.close_brackets? "<% weeeeee %>"
    assert Matches.close_brackets? "%>"
    refute Matches.close_brackets? ">"
    refute Matches.close_brackets? "%"
    refute Matches.close_brackets? " weeeeee "
  end

end

