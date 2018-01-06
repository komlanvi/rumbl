defmodule Rumbl.Schema.User do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias Comeonin.Bcrypt

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
    |> cast(params, [:name, :username])
    |> validate_required([:name, :username])
    |> validate_length(:name, min: 2, max: 20)
  end

  def registration_changeset(user = %__MODULE__{}, params) do
    user
    |> changeset(params)
    |> cast(params, [:password])
    |> validate_required([:password])
    |> validate_length(:password, min: 6, max: 100)
    |> put_pass_hash()
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, Bcrypt.hashpwsalt(password))
      _ ->
        changeset
    end
  end
end
