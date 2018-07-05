defmodule Banking.Server do
  use GenServer

  alias Banking.{Account, Server}

  def start_link({email, _password} = attrs) do
    GenServer.start_link(__MODULE__, attrs, name: via_tuple(email))
  end

  def via_tuple(email) do
    {:via, Registry, {Banking.Account.Registry, email}}
  end

  def init(attrs) do
    {:ok, Account.new(attrs)}
  end

  def handle_call({ :info }, _from, account) do
    state = %Account{ account | balance: Float.round(account.balance, 2)}
    {:reply, {:ok, state}, account}
  end

  def handle_cast({ :cash_in, amount }, account) do
    state = %Account{ account | balance: account.balance + amount}
    {:noreply, state}
  end

  def handle_cast({ :cash_out, amount }, account) do
    state = %Account{ account | balance: account.balance - amount}
    {:noreply, state}
  end

  def new(email, password) do
    DynamicSupervisor.start_child(Banking.Account.Supervisor, {Server, {email, password}})
    {:ok, email}
  end

  def cash_in(email, amount) do
    GenServer.cast(Server.via_tuple(email), { :cash_in, amount })
  end

  def cash_out(email, amount) do
    GenServer.cast(Server.via_tuple(email), { :cash_out, amount })
  end

  def children() do
    DynamicSupervisor.which_children(Banking.Account.Supervisor)
  end

  def all() do
    children()
    |> Enum.reduce([], fn ({_, pid, :worker, _}, acc) ->
      {:ok, account} = GenServer.call(pid, { :info })
       Enum.concat(acc, [account])
    end)
  end

  def clean() do
    :ets.delete_all_objects(:transactions)
    children()
    |> Enum.map(fn({_, pid, :worker, _}) ->
       DynamicSupervisor.terminate_child(Banking.Account.Supervisor, pid)
    end)
  end

  def get_pid(email) do
    email
    |> via_tuple()
    |> GenServer.whereis()
  end

  def balance(email) do
    {:ok, account} = GenServer.call(via_tuple(email), { :info })
    {:ok, account.balance}
  end

end
