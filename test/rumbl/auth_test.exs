defmodule Rumbl.AuthTest do
  use RumblWeb.ConnCase
  alias Rumbl.{Auth, Repo}
  alias RumblWeb.Router.Helpers
  import Rumbl.AppHelpers

  setup %{conn: conn} do
    conn = conn
    |> bypass_through(RumblWeb.Router, :browser)
    |> get("/")

    {:ok, %{conn: conn}}
  end

  test "authenticate_user halt when no current_user exists", %{conn: conn} do
    conn = Auth.authenticate_user(conn, [])
    assert redirected_to(conn) == Helpers.page_path(conn, :index)
    assert conn.halted()
  end

  test "authenticate_user continue when current_user exists", %{conn: conn} do
    conn = conn
    |> assign(:current_user, %Rumbl.App.User{})
    |> Auth.authenticate_user([])

    refute conn.halted()
  end

  describe "" do
    setup :create_user

    test "session contains user_id and conn.assigns current_user when user is succefully logged in", %{conn: conn, user: user} do
      conn = Auth.login(conn, user)

      assert conn.assigns[:current_user]
      assert get_session(conn, :user_id) == user.id
    end

    test "logout drop the session", %{conn: conn, user: user} do
      logout_conn = conn
      |> put_session(:user_id, user.id)
      |> Auth.logout()
      |> send_resp(:ok, "")

      next_conn = get(logout_conn, "/")

      refute get_session(next_conn, :user_id)
    end

    test "Auth.call put user from session to conn.assigns", %{conn: conn, user: user} do
      conn = conn
      |> put_session(:user_id, user.id)
      |> Auth.call(Repo)

      assert conn.assigns[:current_user].id == user.id
    end

    test "Auth.call with no session puts conn.assigns.current_user to nil", %{conn: conn} do
      conn = conn
      |> Auth.call(Repo)

      assert conn.assigns[:current_user] == nil
    end

    test "Login with valid username and password", %{conn: conn, user: user} do
      {:ok, conn} = conn
      |> Auth.login_by_username_and_password(user.username, user.password, [repo: Repo])

      assert conn.assigns[:current_user].username == user.username
      assert get_session(conn, :user_id) == user.id
    end

    test "Login with a not found user", %{conn: conn} do
      {:error, :not_found, _conn} = conn
      |> Auth.login_by_username_and_password("wayne", "lil", [repo: Repo])
    end

    test "Login with a wrong password", %{conn: conn, user: user} do
      {:error, :unauthorized, _conn} = conn
      |> Auth.login_by_username_and_password(user.username, "lil", [repo: Repo])
    end
  end
end