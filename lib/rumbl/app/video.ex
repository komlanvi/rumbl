defmodule Rumbl.App.Video do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rumbl.App.Video

  @required_fields [:title, :url, :description, :category_id]

  schema "videos" do
    field :description, :string
    field :title, :string
    field :url, :string
    belongs_to :user, Rumbl.App.User
    belongs_to :category, Rumbl.App.Category

    timestamps()
  end

  def changeset(%Video{} = video, attrs) do
    video
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:category_id)
  end
end
