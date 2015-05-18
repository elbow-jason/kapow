defmodule Kapow do

  def parse(filename) do
    filename
    |> File.open!
    |> Kapow.Parse.text
  end


end
