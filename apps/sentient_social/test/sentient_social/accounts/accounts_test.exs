defmodule SentientSocial.AccountsTest do
  use SentientSocial.DataCase

  alias SentientSocial.Accounts

  describe "users" do
    alias SentientSocial.Accounts.User

    @valid_attrs %{
      name: "John Doe",
      profile_image_url: "www.website.com/image.png",
      username: "johndoe"
    }
    @update_attrs %{
      name: "Jane Doe",
      profile_image_url: "www.website.com/image2.png",
      username: "janedoe"
    }
    @invalid_attrs %{name: nil, profile_image_url: nil, username: nil}

    @spec user_fixture(map) :: %User{}
    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "get_user_by_username/1 returns an existing user" do
      user = user_fixture()
      assert user == Accounts.get_user_by_username(user.username)
    end

    test "create_or_update_from_twitter/1 creates a new user" do
      auth_user = %{
        name: "John Doe 3",
        profile_image_url: "www.website.com/image3.png",
        screen_name: "johndoe3"
      }

      result = Accounts.create_or_update_from_twitter(auth_user)
      assert {:ok, user} = result
      assert user.name == "John Doe 3"
      assert user.profile_image_url == "www.website.com/image3.png"
      assert user.username == "johndoe3"
    end

    test "create_or_update_from_twitter/1 updates an existing user" do
      auth_user = %{
        name: "John Doe 3",
        profile_image_url: "www.website.com/image3.png",
        screen_name: "johndoe"
      }

      assert {:ok, user} =
               Accounts.create_user(%{
                 username: auth_user.screen_name,
                 profile_image_url: auth_user.profile_image_url,
                 name: auth_user.name
               })

      result = Accounts.create_or_update_from_twitter(auth_user)
      assert {:ok, user} = result
      assert user.name == "John Doe 3"
      assert user.profile_image_url == "www.website.com/image3.png"
      assert user.username == "johndoe"
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

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Accounts.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.name == "Jane Doe"
      assert user.profile_image_url == "www.website.com/image2.png"
      assert user.username == "janedoe"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end