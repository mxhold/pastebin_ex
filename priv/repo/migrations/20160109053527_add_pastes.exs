defmodule PastebinEx.Repo.Migrations.AddPastes do
  use Ecto.Migration

  def change do
    create table(:pastes) do
      add :name, :uuid, null: false
      add :body, :text, null: false
      timestamps
    end
    create index(:pastes, [:name])
  end
end
