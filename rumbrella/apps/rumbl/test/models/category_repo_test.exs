defmodule Rumbl.CategoryRepoTest do
  use Rumbl.ModelCase
  alias Rumbl.Category

  test "alphabetically/1 orders by name" do
    insert_category(%{name: "c"})
    insert_category(%{name: "a"})
    insert_category(%{name: "d"})

    query = Category |> Category.alphabetical()
    query = from c in query, select: c.name
    assert Repo.all(query) == ~w(a c d)
  end
end
