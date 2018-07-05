defmodule Banking.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      {Registry, keys: :unique, name: Banking.Account.Registry},
      {DynamicSupervisor, name: Banking.Account.Supervisor, strategy: :one_for_one}
    ]

    ets_opts = [
      :named_table,
      :set,
      :public,
      read_concurrency: true,
      write_concurrency: true
    ]

    :ets.new(:transactions, ets_opts)

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Banking.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
