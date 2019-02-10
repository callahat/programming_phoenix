defmodule Rumbl.VideoViewTest do
  use Rumbl.ConnCase, async: true
  import Phoenix.View

  test "renders index.html", %{conn: conn} do
    bob = insert_user(%{username: "Bob"})
    videos = [%Rumbl.Video{id: "1", title: "mogs", user: bob},
              %Rumbl.Video{id: "1", title: "scrats", user: bob}]
    content = render_to_string(Rumbl.VideoView, "index.html", conn: conn, videos: videos)

    assert String.contains?(content, "Listing videos")
    for video <- videos do
      assert String.contains?(content, video.title)
    end
  end

  test "renders new.html", %{conn: conn} do
    changeset = Rumbl.Video.changeset(%Rumbl.Video{})
    categories = [{"snacks", 1}]
    content = render_to_string(Rumbl.VideoView, "new.html", conn: conn, categories: categories, changeset: changeset)

    assert String.contains?(content, "New video")
  end

  test "category name for a video with a category", %{conn: _conn} do
    video = insert_video(insert_user(), category: insert_category(%{name: "something"}))

    assert Rumbl.VideoView.category_name(video) == "something"
  end

  test "category name for a video without a category is just N/A", %{conn: _conn} do
    video = insert_video(insert_user())

    assert Rumbl.VideoView.category_name(video) == "N/A"
  end
end
