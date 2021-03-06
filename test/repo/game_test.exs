defmodule SprintPoker.GameTest do
  use SprintPoker.DataCase

  alias SprintPoker.Repo
  alias SprintPoker.Repo.Game
  alias SprintPoker.Repo.User
  alias SprintPoker.Repo.Deck

  @test_user %User{}
  @test_deck %Deck{name: "test deck", cards: []}

  test "don't create empty game" do
    assert_raise Postgrex.Error, fn ->
      %Game{} |> Repo.insert!
    end
  end

  test "don't create game without name" do
    user = @test_user |> Repo.insert!
    deck = @test_deck |> Repo.insert!

    assert_raise Postgrex.Error, fn ->
      %Game{
        owner_id: user.id,
        deck_id: deck.id
      } |> Repo.insert!
    end
  end

  test "don't create game without owner" do
    deck = @test_deck |> Repo.insert!

    assert_raise Postgrex.Error, fn ->
      %Game{
        name: "sample name",
        deck_id: deck.id
      } |> Repo.insert!
    end
  end

  test "don't create game without deck" do
    user = @test_user |> Repo.insert!

    assert_raise Postgrex.Error, fn ->
      %Game{
        name: "sample name",
        owner_id: user.id
      } |> Repo.insert!
    end
  end

  test "create game with name and onwer_id" do
    user = @test_user |> Repo.insert!
    deck = @test_deck |> Repo.insert!

    game = %Game{
      name: "sample name",
      owner_id: user.id,
      deck_id: deck.id
    } |> Repo.insert! |> Repo.preload([:owner, :deck])

    assert game
    assert game.owner == user
    assert game.deck == deck
  end

  test "empty game changeset is not valid" do
    changeset = %Game{} |> Game.changeset(%{})

    refute changeset.valid?
  end

  test "game changeset without name is not valid" do
    user = @test_user |> Repo.insert!
    deck = @test_deck |> Repo.insert!
    changeset = %Game{} |> Game.changeset(%{
      owner_id: user.id,
      deck_id: deck.id
    })

    refute changeset.valid?
  end

  test "game changeset without owner is not valid" do
    deck = @test_deck |> Repo.insert!
    changeset = %Game{} |> Game.changeset(%{
      name: "sample name",
      deck_id: deck.id
    })

    refute changeset.valid?
  end

  test "game changeset without deck is not valid" do
    user = @test_user |> Repo.insert!
    changeset = %Game{} |> Game.changeset(%{
      name: "sample name",
      owner_id: user.id
    })

    refute changeset.valid?
  end

  test "game changeset with name and onwer_id is valid" do
    user = @test_user |> Repo.insert!
    deck = @test_deck |> Repo.insert!

    changeset = %Game{} |> Game.changeset(%{
      name: "sample name",
      owner_id: user.id,
      deck_id: deck.id
    })

    assert changeset.valid?
  end
end
