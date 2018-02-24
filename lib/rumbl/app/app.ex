defmodule Rumbl.App do
  @moduledoc """
  The App context.
  """

  import Ecto.Query, warn: false
  import Ecto

  alias Rumbl.Repo
  alias Rumbl.App.{Video, User, Category}

  @doc """
  Returns the list of videos.

  ## Examples

      iex> list_videos()
      [%Video{}, ...]

  """
  def list_videos do
    Repo.all(Video)
  end

  @doc """
  Returns the list of videos created by user.

  ## Examples

      iex> list_videos(user)
      [%Video{user_id: user.id}, ...]

  """
  def list_videos(%User{} = user) do
    user_videos_query = assoc(user, :videos)
    Repo.all(user_videos_query)
  end

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Returns the list of categories.

  ## Examples

      iex> list_categories()
      [%Category{}, ...]

  """
  def list_categories do
    Repo.all(Category)
  end

  @doc """
  Gets a single video.

  Raises `Ecto.NoResultsError` if the Video does not exist.

  ## Examples

      iex> get_video!(123)
      %Video{}

      iex> get_video!(456)
      ** (Ecto.NoResultsError)

  """
  def get_video!(id), do: Repo.get!(Video, id)

  @doc """
  Gets the video created by user with id.

  Raises `Ecto.NoResultsError` if the Video does not exist.

  ## Examples

      iex> get_video!(user, 123)
      %Video{}

      iex> get_video!(user, 456)
      ** (Ecto.NoResultsError)

  """
  def get_video!(%User{} = user, id), do: Repo.get!(assoc(user, :videos), id)

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the Video does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Gets a single category.

  Raises `Ecto.NoResultsError` if the Category does not exist.

  ## Examples

      iex> get_category!(adventure)
      %Category{name: "adventure"}

      iex> get_category!(romance)
      ** (Ecto.NoResultsError)

  """
  def get_category!(name), do: Repo.get!(Category, name)

  @doc """
  Creates a video.

  ## Examples

      iex> create_video(%{field: value}, %User{id: 5} = user)
      {:ok, %Video{user_id: 5, field: value}}

      iex> create_video(%{field: bad_value}, %User{id: _})
      {:error, %Ecto.Changeset{}}

  """
  def create_video(attrs \\ %{}, %User{} = user) do
    user
    |> build_assoc(:videos)
    |> Video.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a category.

  Raise an exception if something go wrong.

  ## Examples

      iex> create_category(%{field: value})
      {:ok, %Category{}}

      iex> create_category(%{field: bad_value})
      ** (Ecto.SomeException)

  """
  def create_category!(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert!()
  end

  @doc """
  Updates a video.

  ## Examples

      iex> update_video(video, %{field: new_value})
      {:ok, %Video{}}

      iex> update_video(video, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_video(%Video{} = video, attrs) do
    video
    |> Video.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Video.

  ## Examples

      iex> delete_video(video)
      {:ok, %Video{}}

      iex> delete_video(video)
      {:error, %Ecto.Changeset{}}

  """
  def delete_video(%Video{} = video) do
    Repo.delete(video)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking video changes.

  ## Examples

      iex> change_video(video)
      %Ecto.Changeset{source: %Video{}}

  """
  def change_video(%Video{} = video) do
    Video.changeset(video, %{})
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking User changes.

  ## Examples

      iex> change_user(video)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  @doc """
  Returns all the categories as {name, id} ordered by name

  ## Examples

      iex> load_categories()
      [{"Category A", 4}, {"Category B", 1}, ...]
  """
  def load_categories do
    query = Category
    |> Category.categories_name_and_id()
    |> Category.categories_ordered_by_name()

    Repo.all(query)
  end
end
