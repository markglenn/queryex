defmodule QueryEngine.Factory do
  # with Ecto
  use ExMachina.Ecto, repo: Dummy.Repo

  def organization_factory do
    %Dummy.Organization{
      name: sequence(:name, &"Organization #{&1}"),
      website: sequence(:website, &"http://#{&1}.example.com")
    }
  end

  def person_factory do
    %Dummy.Person{
      first_name: sequence(:first_name, &"User#{&1}"),
      last_name: "Doe",
      email: sequence(:email, &"user#{&1}@example.com"),
      organization: build(:organization)
    }
  end
end
