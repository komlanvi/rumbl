defmodule RumblWeb.SessionController do
  use RumblWeb, :controller
  alias Rumbl.Auth
  alias Rumbl.Repo

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => %{"username" => username, "password" => password}}) do
    case Auth.login_by_username_and_password(conn, username, password, repo: Repo) do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "Welcome back #{username}")
        |> redirect(to: page_path(conn, :index))
      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Invalid username/password")
        |> render("new.html")
    end
  end

  def delete(conn, %{"user_id" => user_id}) do

  end
end