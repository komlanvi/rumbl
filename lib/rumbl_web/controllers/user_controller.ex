defmodule RumblWeb.UserController do
  use RumblWeb, :controller
  alias Rumbl.Schema.User
  alias Rumbl.Repo

  def index(conn, _params) do
    users = Repo.all(User)
    render conn, "index.html", users: users
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get(User, id)
    render conn, "show.html", user: user
  end

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"user" => user_inputs}) do
    changeset = User.registration_changeset(%User{}, user_inputs)
    IO.inspect changeset, label: "BBBBBBBBBB"
    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "#{user.username} account has been correctly created!")
        |> redirect(to: user_path(conn, :index))
      {:error, changeset} ->
        IO.inspect changeset, label: "AAAAAAAAA"
        render conn, "new.html", changeset: changeset
    end
  end
end