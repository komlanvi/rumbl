defmodule RumblWeb.VideoController do
  use RumblWeb, :controller

  alias Rumbl.App

  plug :authenticate_user when action in [:index, :show]
  plug :load_categories when action in [:edit, :new]


  def index(conn, _params, user) do
    videos = App.list_videos(user)
    render(conn, "index.html", videos: videos)
  end

  def new(conn, _params, user) do
    changeset = user
    |> build_assoc(:videos)
    |> App.change_video()
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"video" => video_params}, user) do
    case App.create_video(video_params, user) do
      {:ok, video} ->
        conn
        |> put_flash(:info, "Video created successfully.")
        |> redirect(to: video_path(conn, :show, video))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, user) do
    video = App.get_video!(user, id)
    render(conn, "show.html", video: video)
  end

  def edit(conn, %{"id" => id}, user) do
    video = App.get_video!(user, id)
    changeset = App.change_video(video)
    render(conn, "edit.html", video: video, changeset: changeset)
  end

  def update(conn, %{"id" => id, "video" => video_params}, user) do
    video = App.get_video!(user, id)

    case App.update_video(video, video_params) do
      {:ok, video} ->
        conn
        |> put_flash(:info, "Video updated successfully.")
        |> redirect(to: video_path(conn, :show, video))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", video: video, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, user) do
    video = App.get_video!(user, id)
    {:ok, _video} = App.delete_video(video)

    conn
    |> put_flash(:info, "Video deleted successfully.")
    |> redirect(to: video_path(conn, :index))
  end

  defp load_categories(conn, _params) do
    categories = App.load_categories()
    assign(conn, :categories, categories)
  end

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end
end
