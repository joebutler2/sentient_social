defmodule SentientSocial.UserTest do
  use SentientSocial.DataCase

  import SentientSocial.Factory

  alias SentientSocial.Accounts

  describe "users" do
    alias SentientSocial.Accounts.User

    @valid_attrs %{
      name: "John Doe",
      profile_image_url: "www.website.com/image.png",
      email: "johndoe@email.com",
      username: "johndoe",
      twitter_followers_count: 0,
      access_token: "token",
      access_token_secret: "secret"
    }
    @update_attrs %{
      name: "Jane Doe",
      profile_image_url: "www.website.com/image2.png",
      username: "janedoe",
      email: "janedoe@email.com",
      twitter_followers_count: 100,
      access_token: "new_token",
      access_token_secret: "new_secret"
    }
    @invalid_attrs %{email: 1}

    @spec user_fixture(map) :: %User{}
    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = insert(:user)
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = insert(:user)
      assert Accounts.get_user!(user.id) == user
    end

    test "get_user_by_username/1 returns an existing user" do
      user = insert(:user)
      assert user == Accounts.get_user_by_username(user.username)
    end

    test "get_user_by_username/1 returns nil for a non-existent user" do
      assert nil == Accounts.get_user_by_username("notreal")
    end

    test "get_user_by_email/1 returns an existing user" do
      user = insert(:user)
      assert user == Accounts.get_user_by_email(user.email)
    end

    test "get_user_by_email/1 returns nil for a non-existent user" do
      assert nil == Accounts.get_user_by_email("notreal@fake.com")
    end

    test "create_or_update_from_twitter/1 creates a new user" do
      auth_user = %{
        name: "John Doe 3",
        profile_image_url: "www.website.com/image3.png",
        screen_name: "johndoe3",
        followers_count: 100,
        access_token: "new_token",
        access_token_secret: "new_secret"
      }

      result = Accounts.create_or_update_from_twitter(auth_user)
      assert {:ok, user} = result
      assert user.name == "John Doe 3"
      assert user.profile_image_url == "www.website.com/image3.png"
      assert user.username == "johndoe3"
      assert user.twitter_followers_count == 100
      assert user.access_token == "new_token"
      assert user.access_token_secret == "new_secret"
    end

    test "create_or_update_from_twitter/1 updates an existing user" do
      insert(:user, %{
        username: "johndoe",
        profile_image_url: "www.website.com/image3.png",
        name: "User Name",
        access_token: "token",
        access_token_secret: "secret"
      })

      auth_user = %{
        name: "John Doe 3",
        profile_image_url: "www.website.com/image3.png",
        screen_name: "johndoe",
        followers_count: 100,
        access_token: "new_token",
        access_token_secret: "new_secret"
      }

      result = Accounts.create_or_update_from_twitter(auth_user)
      assert {:ok, user} = result
      assert user.name == "John Doe 3"
      assert user.profile_image_url == "www.website.com/image3.png"
      assert user.username == "johndoe"
      assert user.twitter_followers_count == 100
      assert user.access_token == "new_token"
      assert user.access_token_secret == "new_secret"
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.name == "John Doe"
      assert user.profile_image_url == "www.website.com/image.png"
      assert user.username == "johndoe"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "create_user/1 with a duplicate user returns error changeset" do
      assert {:ok, %User{}} = Accounts.create_user(@valid_attrs)
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@valid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = insert(:user)
      assert {:ok, user} = Accounts.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.name == "Jane Doe"
      assert user.profile_image_url == "www.website.com/image2.png"
      assert user.username == "janedoe"
      assert user.twitter_followers_count == 100
      assert user.access_token == "new_token"
      assert user.access_token_secret == "new_secret"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = insert(:user)
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = insert(:user)
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = build(:user)
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
