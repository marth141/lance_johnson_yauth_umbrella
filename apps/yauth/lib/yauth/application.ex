defmodule Yauth.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Yauth.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Yauth.PubSub}
      # Start a worker by calling: Yauth.Worker.start_link(arg)
      # {Yauth.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Yauth.Supervisor)
  end
end
