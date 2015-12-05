defmodule Hydra.MessageController do
  use Hydra.Web, :controller

  alias Hydra.Message

  def index(conn, _params) do
    messages = Repo.all(Message)
    render conn, "index.json", messages: messages
  end

  def create(conn, %{"data" => %{"attributes" => message_params}}) do
    changeset = Message.changeset(%Message{}, message_params)

    case Repo.insert(changeset) do
      {:ok, message} ->
        conn
        |> put_status(:accepted)
        |> put_resp_header("location", message_path(conn, :show, message))
        |> render("show.json", message: message)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Hydra.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    message = Repo.get!(Message, id)
    render(conn, "show.json", message: message)
  end
end
