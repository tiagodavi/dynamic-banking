defmodule Banking.Account do
  defstruct [email: "", balance: 1000.00]

  def new(email) do
    %Banking.Account{
      email: email
    }
  end
end
