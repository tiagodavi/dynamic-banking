defmodule Banking.Account do
  defstruct [email: "", password: "", balance: 1000.00]

  def new({email, password}) do
    %Banking.Account{
      email: email,
      password: Comeonin.Bcrypt.hashpwsalt(password)
    }
  end
end
