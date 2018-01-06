defmodule  Rumbl.Auth do
  @moduledoc false
  import Plug.Conn
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def call(conn, repo) do
    user_id = get_session(conn, :user_id)
    user = user_id && repo.get(Rumbl.Schema.User, user_id)
    assign(conn, :current_user, user)
  end

  def login(conn, user) do
    conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)   # This protect us from session fixation attacks. It tells plug to send
                                        # the session back to client with a different identifier
  end

  def login_by_username_and_password(conn, username, password, opts) do
    repo = Keyword.fetch!(opts, :repo)
    user = repo.get_by(Rumbl.Schema.User, username: username)
    cond do
      user && checkpw(password, user.password_hash) ->
        {:ok, login(conn, user)}
      user ->
        {:error, :unauthorized, conn}
      true ->
        dummy_checkpw() #It simulate a password check with variable timing (Against timing attacks)
        {:error, :not_found, conn}
    end
  end

  def logout(conn) do
    configure_session(conn, drop: true)
  end
end
