defmodule ApiWeb.Router do
  use ApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug ApiWeb.Plugs.Auth
  end

  scope "/api", ApiWeb, as: :api do
    pipe_through :api
    scope "/v1", Api.V1, as: :v1 do
      scope "/banking" do
        get "/", BankingController, :index
        get "/report", BankingController, :report
        post "/open/:email", BankingController, :open
        get "/info/:email", BankingController, :info
        put "/transfer/:source/:destination/:amount", BankingController, :transfer
        put "/cash-out/:email/:amount", BankingController, :cash_out
      end
    end
  end
end
