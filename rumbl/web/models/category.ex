defmodule Rumbl.Category do
  use Rumbl.Web, :model

  schema "categories" do
    field :name, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
  end

  @doc """
  Builds a queryable that sorts alphabetically by name
  """
  def alphabetical(query) do
    from c in query, order_by: c.name
  end

  @doc """
  Builds a queryable that selected the id and name
  """
  def names_and_ids(query) do
    from c in query, select: {c.name, c.id}
  end
end
