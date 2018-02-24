defmodule RumblWeb.VideoControllerTest do
  use RumblWeb.ConnCase

  import Rumbl.AppHelpers
  alias Rumbl.{App, Repo}

  @create_video_attrs %{description: "d", title: "t", url: "url"}
  @create_user_attrs %{name: "new_name", username: "new_username", password: "new_password"}
  @valid_update_video_attrs %{description: "description of new", title: "title new", url: "new.com"}

  describe "edit video" do
    setup [:create_user, :create_category, :create_video]

    test "edit choosen video", %{video: video} do
      assert "title" === video.title
      assert "description" === video.description
      assert "url" === video.url
    end
  end

  test "require user authentication on all actions", %{conn: conn} do
    Enum.each([
      get(conn, video_path(conn, :index)),
      get(conn, video_path(conn, :show, 123)),
      get(conn, video_path(conn, :edit, 123)),
      put(conn, video_path(conn, :update, 123, %{})),
      get(conn, video_path(conn, :new)),
      post(conn, video_path(conn, :create, video: %{})),
      delete(conn, video_path(conn, :delete, 123))
    ],
      fn conn ->
        assert html_response(conn, 302)
        assert conn.halted
      end
    )
  end

  describe "Autenticated user" do
    setup [:create_user, :create_category, :create_video, :log_user_in]

    test "list all user videos on index", %{conn: conn, video: video, category: category} do
      {:ok, another_user} = App.create_user(%{username: "moris", name: "Moore", password: "no_more"})
      {:ok, another_video} = App.create_video(%{description: "labla", url: "blabla.com", title: "totolo", category_id: category.id}, another_user)

      conn = get conn, video_path(conn, :index)
      assert html_response(conn, 200) =~ ~r/Listing Videos/
      assert String.contains?(conn.resp_body, video.title)
      refute String.contains?(conn.resp_body, another_video.title)
    end
  end

  describe "Create video" do
    setup [:create_user, :create_category, :create_video, :log_user_in]

    test "Create user video and redirect", %{conn: conn, category: category, user: user} do
      count_before_insert = count_video(Rumbl.App.Video)
      conn = post conn, video_path(conn, :create, video: %{title: "V", description: "V", url: "http://v.com", category_id: category.id})
      video = Repo.get_by(Rumbl.App.Video, title: "V", description: "V")
      assert redirected_to(conn) == video_path(conn, :show, video)
      assert video.user_id == user.id
      refute count_before_insert == count_video(Rumbl.App.Video)
    end

    test "Does not create video because data provided are incorrect", %{conn: conn, category: category} do
      count_before_insert = count_video(Rumbl.App.Video)
      conn = post conn, video_path(conn, :create, video: %{title: "V", url: "http://v.com", category_id: category.id})
      assert html_response(conn, 200) =~ ~r/Oops, something went wrong! Please check the errors below./
      assert count_before_insert == count_video(Rumbl.App.Video)
    end

    test "User cannot manage videos they don't own", %{conn: conn, category: category, user: user} do
    {:ok, video} = @create_video_attrs
    |> Map.merge(%{category_id: category.id})
    |> App.create_video(user)

    {:ok, non_owner} = App.create_user(@create_user_attrs)
    conn = login(conn, non_owner)

    assert_error_sent :not_found, fn ->
      put conn, video_path(conn, :update, video, video: @valid_update_video_attrs)
    end
    assert_error_sent :not_found, fn ->
      get conn, video_path(conn, :show, video)
    end
    assert_error_sent :not_found, fn ->
      get conn, video_path(conn, :edit, video)
    end
    assert_error_sent :not_found, fn ->
      delete conn, video_path(conn, :delete, video)
    end
    end
  end

  defp count_video(query) do
    Repo.one!(from v in query, select: count(v.id))
  end
end
