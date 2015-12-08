defmodule Hydra.Repo do
  use Ecto.Repo, otp_app: :hydra

  def log(%Ecto.Changeset{valid?: true} = changeset) do
    status = do_log(changeset)
    {status, changeset}
  end

  def log(%Ecto.Changeset{valid?: false} = changeset) do
    {:error, changeset}
  end

  defp do_log(%Ecto.Changeset{changes: changes, model: model}) do
    KafkaEx.produce(topic_name(model.__struct__), 0, Poison.encode!(changes))
  end

  defp topic_name(model_name) do
    case model_name do
      Hydra.Message -> "hydra_messages"
    end
  end
end
