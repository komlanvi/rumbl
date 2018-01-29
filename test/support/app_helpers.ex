defmodule Rumbl.AppHelpers do
  @moduledoc false

  alias Rumbl.App

  @create_video_attrs %{description: "description", title: "title", url: "url", category_id: 1}

  @create_user_attrs %{name: "name", username: "username", password: "password"}

  @create_category_attrs %{id: 1, name: "category"}

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
end