defmodule Dummy.OrganizationTest do
  use QueryEngine.ModelCase, async: true
  import QueryEngine.Factory

  alias Dummy.Organization

  test "changeset with valid attributes" do
    changeset = Organization.changeset(%Organization{}, params_for(:organization))
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Organization.changeset(%Organization{}, %{})
    refute changeset.valid?
  end
end
