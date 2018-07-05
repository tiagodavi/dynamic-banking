defmodule ApiWeb.Plugs.Auth do
  import Plug.Conn
  import Phoenix.Controller, only: [json: 2]

  @backoffice "backoffice"

  def init(_params) do
  end

  def call(conn, _params) do

    token = get_req_header(conn, "authorization")

    if valid_token?(token) do
       conn
    else
      data = %{
        "error" => "Access Denied",
        "info"  => "You don't have credentials to access this resource."
      }
      conn
      |> put_status(401)
      |> json(data)
      |> halt()
    end
  end

  defp valid_token?(["Basic " <> token]) do
    [email, password] = Base.decode64!(token)
    |> String.split(":")
    email == @backoffice && password == @backoffice
  end
  defp valid_token?(_), do: false

end
