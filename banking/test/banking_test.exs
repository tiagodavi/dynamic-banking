defmodule BankingTest do
  use ExUnit.Case, async: true

  @default_email "tiago.asp.net@gmail.com"

  setup do
    Banking.clean()
    :ok
  end

  test ".all returns a list of accounts when there are accounts" do
    Banking.open("tiago.asp.net1@gmail.com")
    Banking.open("tiago.asp.net2@gmail.com")

    response = Banking.all()
    |> Enum.count()

    assert response == 2
  end

  test ".all returns empty list when there are no accounts" do
    response = Banking.all()
    assert response == []
  end

  test ".open returns email when account has just been opened" do
    assert {:ok, email} = Banking.open(@default_email)
    assert email == "tiago.asp.net@gmail.com"
  end

  test ".open returns error when account already exists" do
    assert {:ok, email} = Banking.open(@default_email)
    assert {:error, "Account already exists"} = Banking.open(email)
  end

  test ".is_open? returns true when account is opened" do
    {:ok, email} = Banking.open(@default_email)
    assert Banking.is_open?(email) == true
  end

  test ".is_open? returns false when account is not opened" do
    response_1 = Banking.is_open?(000)
    response_2 = Banking.is_open?("notexist@test.com")
    assert response_1 == false
    assert response_2 == false
  end

  test ".info returns account with R$1.000,00 in balance when account exists" do
    {:ok, email} = Banking.open(@default_email)
    assert {:ok, %Banking.Account{} = account} = Banking.info(email)
    assert account.email == @default_email
    assert account.balance == 1000.00
  end

  test ".info returns error when account does not exist" do
    assert {:error, "Account not found"} = Banking.info("")
  end

  test ".cash_out decreases balance when is able to get cash" do
    assert {:ok, email} = Banking.open(@default_email)
    assert {:ok, _amount} = Banking.cash_out(email, 399.00)
    assert {:ok, account} = Banking.info(email)
    assert account.balance == 601.0
  end

  test ".cash_out returns error when amount is invalid" do
    assert {:ok, email} = Banking.open(@default_email)
    assert {:error, "Invalid Amount"} = Banking.cash_out(email, 500)
  end

  test ".cash_out returns error when account does not exist" do
    assert {:error, "Account not found"} = Banking.cash_out("", 500.00)
  end

  test ".cash_out returns error when there is no balance enough" do
    assert {:ok, email} = Banking.open(@default_email)
    assert {:error, "There is no balance enough"} = Banking.cash_out(email, 1001.00)
  end

  test ".transfer decreases/increases balance when is able to transfer" do
    assert {:ok, source} = Banking.open("tiago.asp.net1@gmail.com")
    assert {:ok, destination} = Banking.open("tiago.asp.net2@gmail.com")
    assert {:ok, _amount} = Banking.transfer(source, destination, 250.0)
    assert {:ok, source_account} = Banking.info(source)
    assert {:ok, destination_account} = Banking.info(destination)
    assert source_account.balance == 750.0
    assert destination_account.balance == 1250.0
  end

  test ".transfer returns error when amount is invalid" do
    assert {:ok, source} = Banking.open("tiago.asp.net1@gmail.com")
    assert {:ok, destination} = Banking.open("tiago.asp.net2@gmail.com")
    assert {:error, "Invalid Amount"} = Banking.transfer(source, destination, 250)
  end

  test ".transfer returns error when source and destination are the same" do
    assert {:ok, source} = Banking.open(@default_email)
    assert {:error, "Source and Destination are the same"} = Banking.transfer(source, source, 250.0)
  end

  test ".transfer returns error when either source or destination doesn't exist" do
    assert {:ok, source} = Banking.open(@default_email)
    assert {:error, "Account (source or destination) not found"} = Banking.transfer(source, "", 250.0)
  end

  test ".transfer returns error when there is no balance enough" do
    assert {:ok, source} = Banking.open("tiago.asp.net1@gmail.com")
    assert {:ok, destination} = Banking.open("tiago.asp.net2@gmail.com")
    assert {:error, "There is no balance enough"} = Banking.transfer(source, destination, 1500.0)
  end

  test ".report returns total of all transactions" do
    assert {:ok, email} = Banking.open("tiago.asp.net@gmail.com")
    assert {:ok, _amount} = Banking.cash_out(email, 399.00)
    assert {:ok, _amount} = Banking.cash_out(email, 125.00)
    assert {:ok, _amount} = Banking.cash_out(email, 78.00)

    response = Banking.report()
    |> Enum.at(0)

    assert response.amount == 602.0
  end

  test ".report returns empty list when there are no transactions" do
    response = Banking.report()
    assert response == []
  end

end
