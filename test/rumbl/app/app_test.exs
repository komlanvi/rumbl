defmodule Rumbl.AppTest do
  use Rumbl.DataCase

  alias Rumbl.App
  import Rumbl.AppHelpers

  describe "videos" do
    alias Rumbl.App.Video

    @create_video_attrs %{description: "description of a", title: "title a", url: "a.com", category_id: 1}
    @update_video_attrs %{description: "description of b", title: "title b", url: "b.com", category_id: 1}
    @invalid_video_attrs %{description: nil, title: nil, url: nil, category_id: nil}

    @create_video_attrs %{description: "description of a", title: "title a", url: "a.com", category_id: 1}
    @update_video_attrs %{description: "description of b", title: "title b", url: "b.com"}
    @invalid_video_attrs %{description: nil, title: nil, url: nil, category_id: nil}

    setup [:create_user, :create_category, :create_video]

    test "list_videos/0 returns all videos", %{video: video} do
      assert App.list_videos() == [video]
    end

    test "get_video!/1 returns the video with given id", %{video: video} do
      assert App.get_video!(video.id) == video
    end

    test "create_video/1 with valid data creates a video", %{user: user, category: category} do
      assert {:ok, %Video{} = video} = @create_video_attrs
      |> Map.merge(%{category_id: category.id})
      |> App.create_video(user)
      assert video.description == "description of a"
      assert video.title == "title a"
      assert video.url == "a.com"
    end

    test "create_video/1 with invalid data returns error changeset", %{user: user} do
      assert {:error, %Ecto.Changeset{}} = App.create_video(@invalid_video_attrs, user)
    end

    test "update_video/2 with valid data updates the video", %{video: video} do
      assert {:ok, updated_video} = App.update_video(video, @update_video_attrs)
      assert %Video{} = updated_video
      assert updated_video.description == "description of b"
      assert updated_video.title == "title b"
      assert updated_video.url == "b.com"
    end

    test "update_video/2 with invalid data returns error changeset", %{video: video} do
      assert {:error, %Ecto.Changeset{}} = App.update_video(video, @invalid_video_attrs)
      assert video == App.get_video!(video.id)
    end

    test "delete_video/1 deletes the video", %{video: video} do
      assert {:ok, %Video{}} = App.delete_video(video)
      assert_raise Ecto.NoResultsError, fn -> App.get_video!(video.id) end
    end

    test "change_video/1 returns a video changeset", %{video: video} do
      assert %Ecto.Changeset{} = App.change_video(video)
    end
  end
end
