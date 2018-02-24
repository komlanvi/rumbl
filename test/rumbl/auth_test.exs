defmodule Rumbl.AuthTest do
  use RumblWeb.ConnCase
  alias Rumbl.Auth

  test "authenticate_user halt when no current_user exists", %{conn: conn} do
    conn = Auth.authenticate_user(conn, [])
    assert conn.halted()
  end
end