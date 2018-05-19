defmodule QueryEngine.Interface.Results.Test do
  use QueryEngine.ModelCase, async: true

  import QueryEngine.Factory

  alias QueryEngine.Interface.Results

  describe "build" do
    test "simple query" do
      person = insert(:person)
      assert Results.build([person], []) == %Results{data: [person]}
    end

    test "includes side loaded data" do
      person = insert(:person)
      results = Results.build([person], ["organization"])

      assert Enum.map(results.included, &(&1.id)) == [person.organization_id]
    end

    test "includes deeper side loaded data" do
      person = insert(:person)
      results = Results.build([person], ["organization.country"])

      assert Enum.map(results.included, &(&1.id)) == [person.organization_id, person.organization.country_id]
    end

    test "shows side loaded in order by type" do
      person1 = insert(:person)
      person2 = insert(:person)
      results = Results.build([person1, person2], ["organization.country"])

      assert Enum.map(results.included, &(&1.id)) == [
        person1.organization_id,
        person2.organization_id,
        person1.organization.country_id,
        person2.organization.country_id
      ]

    end
  end
end
