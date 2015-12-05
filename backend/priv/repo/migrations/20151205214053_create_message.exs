defmodule Hydra.Repo.Migrations.CreateMessage do
  use Ecto.Migration

  def change do
    create table(:messages, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :body, :string, size: 10_000

      timestamps
    end
  end
end
