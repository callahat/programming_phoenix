defmodule Rumbl.Video do
  use Rumbl.Web, :model

  @permitted_fields ~w(url title description category_id)

  schema "videos" do
    field :url, :string
    field :title, :string
    field :description, :string
    belongs_to :user, Rumbl.User
    belongs_to :category, Rumbl.Category

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @permitted_fields, [])
    |> validate_required([:url, :title, :description])
  end
end
