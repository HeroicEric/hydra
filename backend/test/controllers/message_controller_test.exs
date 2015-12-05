defmodule Hydra.MessageControllerTest do
  use Hydra.ConnCase

  alias Hydra.Message
  @valid_attrs %{body: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, message_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    message = Repo.insert! %Message{}

    conn = get conn, message_path(conn, :show, message)

    assert json_response(conn, 200)["data"] == %{
      "id" => message.id,
      "type" => "messages",
      "attributes" => %{
        "body" => message.body
      }
    }
  end

  # See https://github.com/phoenixframework/phoenix_ecto/issues/28
  @tag :skip
  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, message_path(conn, :show, "asdasdas")
    end
  end

  test "accepts new message when data is valid", %{conn: conn} do
    data = %{
      type: "messages",
      attributes: %{
        body: "something"
      }
    }

    conn = post conn, message_path(conn, :create), data: data

    assert json_response(conn, 202)["data"]["id"]
  end

  test "does not accept and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, message_path(conn, :create), data: %{ attributes: @invalid_attrs }

    assert json_response(conn, 422)["errors"] != %{}
  end
end
