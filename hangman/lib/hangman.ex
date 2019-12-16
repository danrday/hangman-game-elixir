defmodule Hangman do
  def hello do
    IO.puts Dictionary.random_word()
  end

  alias Hangman.Game

  defdelegate new_game(), to: Game

end
