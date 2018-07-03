defmodule Banking do

  alias Banking.Server

  defguard valid_amount(amount) when is_float(amount) and amount > 0.0

  def all() do
    Server.all()
  end

  def clean() do
    Server.clean()
  end

  def open(email) do
    if is_open?(email) do
      {:error, "Account already exists"}
    else
      Server.new(email)
    end
  end

  def is_open?(email) do
    case Server.get_pid(email) do
      nil -> false
      _pid -> true
    end
  end

  def cash_out(email, amount)
  when valid_amount(amount) do
    if is_open?(email) do
      {:ok, balance} = Server.balance(email)
      if(balance >= amount) do
        Server.cash_out(email, amount)
        IO.inspect "An email has been sent here..."
        {:ok, amount}
      else
        {:error, "There is no balance enough"}
      end
    else
      {:error, "Account not found"}
    end
  end
  def cash_out(_,_), do: {:error, "Invalid Amount"}

  def transfer(source_email, destination_email, amount)
  when valid_amount(amount) do
    cond do
      source_email == destination_email ->
        {:error, "Source and Destination are the same"}

      is_open?(source_email) &&
      is_open?(destination_email) ->
        {:ok, source_balance} = Server.balance(source_email)
        if(source_balance >= amount) do
          Server.cash_out(source_email, amount)
          Server.cash_in(destination_email, amount)
          IO.inspect "An email has been sent here..."
          {:ok, amount}
        else
          {:error, "There is no balance enough"}
        end

      true ->
        {:error, "Account (source or destination) not found"}
    end
  end
  def transfer(_,_,_), do: {:error, "Invalid Amount"}

  def balance(email) do
    if is_open?(email) do
      Server.balance(email)
    else
      {:error, "Account not found"}
    end
  end

end
