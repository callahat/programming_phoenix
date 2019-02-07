defmodule Rumbl.User do
  use Rumbl.Web, :model

  schema "users" do
    field :name, :string
    field :username, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps
  end

  # :empty (what the book said to use) was causing an error, it said it wanted a map, so I gave it an empty map.
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, ~w(name username), [])
    |> validate_length(:username, min: 1, max: 20)
  end
end
