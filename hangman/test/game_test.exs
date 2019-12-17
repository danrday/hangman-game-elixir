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
       game = Game.new_game() |> Map.put(:game_state, state)
      assert ^game = Game.make_move(game, "x")
    end
  end

  test "first occurrence of letter is not already used" do
    game = Game.new_game()
    game = Game.make_move(game, "y")
    assert game.game_state != :already_used
  end


  test "second occurrence of letter is not already used" do
    game = Game.new_game()
    game = Game.make_move(game, "x")
    assert game.game_state != :already_used
    game = Game.make_move(game, "x")
    assert game.game_state == :already_used
  end

  test "a good guess is recognized" do
    game = Game.new_game("wibble")
    game = Game.make_move(game, "w")
    assert game.game_state == :good_guess
    assert game.turns_left == 7
  end

  test "bad guess is recognized" do
    game = Game.new_game("wibble")
    game= Game.make_move(game, "x")
    assert game.game_state == :bad_guess
    assert game.turns_left == 6
  end

  test "lost game is recognized" do
    game = Game.new_game("w")
    game = Game.make_move(game, "x")
    game = Game.make_move(game, "z")
    game = Game.make_move(game, "c")
    game = Game.make_move(game, "v")
    game = Game.make_move(game, "n")
    game = Game.make_move(game, "m")
    game = Game.make_move(game, "q")
    assert game.game_state == :lost
  end

  test "a won game is recognized" do
    moves = [
      {"w", :good_guess},
      {"i", :good_guess},
      {"b", :good_guess},
      {"l", :good_guess},
      {"e", :won}
    ]

    game = Game.new_game("wibble")

    Enum.reduce(moves, game, fn {guess, state}, acc ->
      updated_game = Game.make_move(acc, guess)
      assert updated_game.game_state == state
      updated_game
    end)

  end


end
