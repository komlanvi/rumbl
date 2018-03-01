defmodule Rumbl.AppHelpers do
  @moduledoc false

  alias Rumbl.{App, Auth}

  @create_video_attrs %{description: "description", title: "title", url: "url"}

  @create_user_attrs %{name: "name", username: "username", password: "password"}

  @create_category_attrs %{name: "category"}

  def create_video(context) do
    user = Map.fetch!(context, :user)
    category = Map.fetch!(context, :category)
    {:ok, video} = @create_video_attrs
    |> Map.merge(%{category_id: category.id})
    |> App.create_video(user)

    {:ok, video: video}
  end

  def create_user(_) do
    {:ok, user} = App.create_user(@create_user_attrs)
    {:ok, user: user}
  end

  def create_category(_) do
    category = App.create_category!(@create_category_attrs)
    {:ok, category: category}
  end

  def log_user_in(context) do
    conn = Map.fetch!(context, :conn)
    user = Map.fetch!(context, :user)

    {:ok, conn: conn |> Plug.Test.init_test_session(a: "b") |> Auth.login(user)}
  end

  def login(conn, user = %Rumbl.App.User{}) do
    conn
    |> Plug.Test.init_test_session(a: "b")
    |> Auth.login(user)
  end
end