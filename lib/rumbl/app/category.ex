defmodule Rumbl.App.Category do
  use Ecto.Schema
  import Ecto.Changeset
  alias Rumbl.App.Category


  schema "categories" do
    field :name, :string

    timestamps()
  end

  def changeset(%Category{} = category, attrs) do
    category
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end

  @doc """
  Returns a query to list categories ordered by name.

  ## Examples

      iex> Repo.all categories_ordered_by_name()
      [%Category{name: "A"}, %Category{name: "B"}, ...]

  """
  def categories_ordered_by_name(query) do
    from c in query, order_by: c.name
  end

  @doc """
  Returns a query that list categories as {name, id}.

  ## Examples

      iex> Repo.all categories_ordered_by_name()
      [{name: "A", id: 1}, {name: "C", id: 2}, ...]

  """
  def categories_name_and_id(query) do
    from c in query, select: {c.name, c.id}
  end
end
