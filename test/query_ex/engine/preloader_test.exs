defmodule QueryEx.Engine.Preloader.Test do
  use QueryEx.ModelCase, async: true
  doctest QueryEx.Engine.Preloader

  import QueryEx.Factory
  alias QueryEx.Engine.Preloader

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
