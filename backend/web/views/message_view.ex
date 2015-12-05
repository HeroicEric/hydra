defmodule Hydra.MessageView do
  use Hydra.Web, :view

  def render("index.json", %{messages: messages}) do
    %{data: render_many(messages, Hydra.MessageView, "message.json")}
  end

  def render("show.json", %{message: message}) do
    %{data: render_one(message, Hydra.MessageView, "message.json")}
  end

  def render("message.json", %{message: message}) do
    %{
      type: "messages",
      id: message.id,
      attributes: %{
        body: message.body
      }
    }
  end
end
