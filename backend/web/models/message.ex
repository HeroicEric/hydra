defmodule Hydra.Message do
  use Hydra.Web, :model

  @primary_key {:id, :binary_id, autogenerate: false}

  schema "messages" do
    field :body, :string

    timestamps
  end

  def insert_changeset(model, params \\ :empty) do
    model
    |> cast(params, ~w(body), [])
    |> validate_length(:body, min: 1, max: 5_000)
    |> put_uuid()
  end

  defp put_uuid(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true} ->
        put_change(changeset, :id, Ecto.UUID.generate)
      _ ->
        changeset
    end
  end
end
