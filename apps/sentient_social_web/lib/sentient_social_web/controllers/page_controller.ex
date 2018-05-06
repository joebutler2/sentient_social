defmodule SentientSocialWeb.PageController do
  use SentientSocialWeb, :controller
  alias SentientSocial.Accounts
  alias SentientSocial.Twitter

  @spec index(map, map) :: map
  def index(conn, _params) do
    keywords =
      conn
      |> get_session(:current_user)
      |> Accounts.get_user!()
      |> Accounts.list_keywords()
      |> Enum.map(fn keyword ->
        %{
          id: keyword.id,
          text: keyword.text
        }
      end)

    muted_keywords =
      conn
      |> get_session(:current_user)
      |> Accounts.get_user!()
      |> Accounts.list_muted_keywords()
      |> Enum.map(fn keyword ->
        %{
          id: keyword.id,
          text: keyword.text
        }
      end)

    automated_interactions =
      conn
      |> get_session(:current_user)
      |> Accounts.get_user!()
      |> Twitter.latest_automated_interactions()
      |> Enum.map(fn interaction ->
        %{
          id: interaction.id,
          tweet_user_screen_name: interaction.tweet_user_screen_name,
          tweet_text: interaction.tweet_text,
          tweet_url: interaction.tweet_url,
          inserted_at: interaction.inserted_at
        }
      end)

    conn
    |> assign(:keywords, keywords)
    |> assign(:muted_keywords, muted_keywords)
    |> assign(:automated_interactions, automated_interactions)
    |> render("index.html")
  end
end
