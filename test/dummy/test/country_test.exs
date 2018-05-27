defmodule Dummy.CountryTest do
  use QueryEx.ModelCase, async: true
  import QueryEx.Factory

  alias Dummy.Country

  test "changeset with valid attributes" do
    changeset = Country.changeset(%Country{}, params_for(:country))
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Country.changeset(%Country{}, %{})
    refute changeset.valid?
  end
end

