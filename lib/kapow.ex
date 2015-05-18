defmodule Kapow do

  def parse(filename) do
    filename
    |> File.read!
    |> Kapow.Parse.text
  end


end
