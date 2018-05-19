defmodule QueryEngine.Engine.Preloader.Test do
  use QueryEngine.ModelCase, async: true

  import QueryEngine.Factory
  alias QueryEngine.Engine.Preloader

  describe "load" do
    setup do
      [person: insert(:person)]
    end

    test "with single preload", %{person: person} do
      query =
        Dummy.Person
        |> Preloader.preload_path("organization")
        |> Dummy.Repo.one

      assert query.organization.id == person.organization.id
    end

    test "with duplicate preload", %{person: person} do
      query =
        Dummy.Person
        |> Preloader.preload_path("organization")
        |> Preloader.preload_path("organization")
        |> Dummy.Repo.one

      assert query.organization.id == person.organization.id
    end

    test "with nested preload", %{person: person} do
      query =
        Dummy.Person
        |> Preloader.preload_path("organization.country")
        |> Dummy.Repo.one

      assert query.organization.country.id == person.organization.country.id
    end
  end
end
