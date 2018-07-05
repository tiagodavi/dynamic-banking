defmodule ApiWeb.Api.V1.BankingController do
  use ApiWeb, :controller

  def index(conn, _params) do
    render conn, "index.json", %{accounts: Banking.all()}
  end

  def open(conn, %{"email" => email}) do
    case Banking.open(email) do
      {:ok, email} ->
        render conn, "open.json", %{email: email}
      {:error, reason} ->
        render conn, "error.json", %{error: reason}
    end
  end

  def info(conn, %{"email" => email}) do
    case Banking.info(email) do
      {:ok, account} ->
        render conn, "account.json", %{account: account}
      {:error, reason} ->
        render conn, "error.json", %{error: reason}
    end
  end

  def report(conn, _params) do
    render conn, "report.json", %{report: Banking.report()}
  end

  def transfer(conn, params) do
    {amount, _} = Float.parse(params["amount"])
    case Banking.transfer(
      params["source"],
      params["destination"],
      amount) do
      {:ok, amount} ->
        render conn, "transfer.json", %{amount: amount}
      {:error, reason} ->
        render conn, "error.json", %{error: reason}
    end
  end

  def cash_out(conn, params) do
    {amount, _} = Float.parse(params["amount"])
    case Banking.cash_out(
      params["email"],
      amount) do
      {:ok, amount} ->
        render conn, "transfer.json", %{amount: amount}
      {:error, reason} ->
        render conn, "error.json", %{error: reason}
    end
  end

end
