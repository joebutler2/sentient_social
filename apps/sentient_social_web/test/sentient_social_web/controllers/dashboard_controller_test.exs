defmodule SentientSocialWeb.DashboardControllerTest do
  use SentientSocialWeb.ConnCase, async: true

  import SentientSocial.Factory

  describe "GET /dashboard" do
    test "shows log out link", %{conn: conn} do
      conn =
        conn
        |> sign_in()
        |> get("/dashboard")

      assert html_response(conn, 200) =~ "Log Out"
    end

    test "lists current user's keywords", %{conn: conn} do
      user = insert(:user)
      insert(:keyword, %{text: "keyword1", user: user})
      insert(:keyword, %{text: "keyword2", user: user})

      conn =
        conn
        |> sign_in(user)
        |> get("/dashboard")

      assert html_response(conn, 200) =~ "Keywords"
      assert html_response(conn, 200) =~ "keyword1"
      assert html_response(conn, 200) =~ "keyword2"
    end

    test "lists current user's muted keywords", %{conn: conn} do
      user = insert(:user)
      insert(:muted_keyword, %{text: "keyword1", user: user})
      insert(:muted_keyword, %{text: "keyword2", user: user})

      conn =
        conn
        |> sign_in(user)
        |> get("/dashboard")

      assert html_response(conn, 200) =~ "Keywords"
      assert html_response(conn, 200) =~ "keyword1"
      assert html_response(conn, 200) =~ "keyword2"
    end

    test "lists current user's automated interactions", %{conn: conn} do
      user = insert(:user)

      insert(:automated_interaction, %{
        tweet_text: "keyword1",
        tweet_url: "www.twitter.com/i/web/status/1",
        tweet_user_screen_name: "user",
        user: user
      })

      insert(:automated_interaction, %{
        tweet_text: "keyword2",
        tweet_url: "www.twitter.com/i/web/status/2",
        tweet_user_screen_name: "user",
        user: user
      })

      conn =
        conn
        |> sign_in(user)
        |> get("/dashboard")

      assert html_response(conn, 200) =~ "Automated Interactions"
      assert html_response(conn, 200) =~ "keyword1"
      assert html_response(conn, 200) =~ "keyword2"
      assert html_response(conn, 200) =~ "user"
      assert html_response(conn, 200) =~ "www.twitter.com/i/web/status/1"
      assert html_response(conn, 200) =~ "www.twitter.com/i/web/status/2"
    end
  end
end