defmodule RumblWeb.UserController do
  use RumblWeb, :controller

  alias Rumbl.App
  alias Rumbl.Auth
  alias Rumbl.App.User

  plug :authenticate_user when action in [:index, :show]

  def index(conn, _params) do
    users = App.list_users()
    render conn, "index.html", users: users
  end

  def show(conn, %{"id" => id}) do
    user = App.get_user!(id)
    render conn, "show.html", user: user
  end

  def new(conn, _params) do
    changeset = App.change_user(%User{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do
    case App.create_user(user_params) do
      {:ok, user} ->
        conn
        |> Auth.login(user)
        |> put_flash(:info, "#{user.username} account has been correctly created!")
        |> redirect(to: user_path(conn, :index))
      {:error, changeset} ->
        render conn, "new.html", changeset: changeset
    end
  end
end
