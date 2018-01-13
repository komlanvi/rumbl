defmodule Rumbl.App.Video do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rumbl.App.Video


  schema "videos" do
    field :description, :string
    field :title, :string
    field :url, :string
    belongs_to :user, Rumbl.App.User

    timestamps()
  end

  @doc false
  def changeset(%Video{} = video, attrs) do
    video
    |> cast(attrs, [:title, :url, :description])
    |> validate_required([:title, :url, :description])
  end
end
