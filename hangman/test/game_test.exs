defmodule GameTest do
  use ExUnit.Case
  doctest Hangman.Game

  alias Hangman.Game
  #    assert Enum.find(letters, &(String.to_charlist(&1) < 97 || String.to_charlist(&1) > 122 ))



    test "new_game returns structure" do
    game = Game.new_game()
    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0
  end

  test "state isn't changed for :won or :lost game" do
    for state <- [:won, :lost] do
       game = Game.new_game() |> Map.put(:game_state, :won)
      assert {^game, _} = Game.make_move(game, "x")
    end
  end

  test "first occurrence of letter is not already used" do
    game = Game.new_game()
    { game, _tally } = Game.make_move(game, "y")
    assert game.game_state != :already_used
  end


  test "second occurrence of letter is not already used" do
    game = Game.new_game()
    { game, _tally } = Game.make_move(game, "x")
    assert game.game_state != :already_used
    { game, _tally } = Game.make_move(game, "x")
    assert game.game_state == :already_used
  end

  test "a good guess is recognized" do
    game = Game.new_game("wibble")
    {game, _tally} = Game.make_move(game, "w")
    assert game.state = :good_guess
    assert game.turns_left == 7
  end


end