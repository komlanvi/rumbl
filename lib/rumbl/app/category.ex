defmodule Rumbl.App.Category do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rumbl.App.Category


  schema "categories" do
    field :name, :string

    timestamps()
  end

  def changeset(%Category{} = category, attrs) do
    category
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
