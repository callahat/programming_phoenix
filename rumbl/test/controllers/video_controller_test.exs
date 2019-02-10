defmodule VideoControllerTest do
  use Rumbl.ConnCase

  setup %{conn: conn} = config do
    if username = config[:login_as] do
      user = insert_user(%{username: username})
      conn = Plug.Conn.assign(conn(), :current_user, user)
      {:ok, conn: conn, user: user}
    else
      :ok
    end
  end

  @tag login_as: "maxheadroom"
  test "lists all the user's videos on the index", %{conn: conn, user: user} do
    user_video = insert_video(user, title: "Some video")
    other_video = insert_video(insert_user(%{username: "Doug"}), title: "Porkchop Sandwiches")

    conn = get conn, video_path(conn, :index)
    assert html_response(conn, 200) =~ ~r/Listing videos/
    assert String.contains?(conn.resp_body, user_video.title)
    refute String.contains?(conn.resp_body, other_video.title)
  end

  test "requires user authentication on all actions", %{conn: conn} do
    Enum.each([
      get(conn, video_path(conn, :new)),
      get(conn, video_path(conn, :index)),
      get(conn, video_path(conn, :show, "123")),
      get(conn, video_path(conn, :edit, "123")),
      put(conn, video_path(conn, :update, "123", %{})),
      post(conn, video_path(conn, :create, %{})),
      delete(conn, video_path(conn, :delete, "123")),
    ], &assert_redirect_when_unauthenticated(&1))
  end

  defp assert_redirect_when_unauthenticated(conn) do
    assert html_response(conn, 302)
    assert conn.halted
  end
end
