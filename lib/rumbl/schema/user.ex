defmodule Rumbl.Schema.User do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [:name, :username, :password]

  schema "users" do
    field :name, :string
    field :username, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end

  def changeset(user = %__MODULE__{}, params \\ %{}) do
    user
    |> cast(params, @required_fields, [])
    |> validate_required(@required_fields)
    |> validate_length(:name, min: 2, max: 20)
  end
end
