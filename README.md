## Banking
A databaseless project which shows how to deal with Dynamic Supervisors and ETS to hold state.

I tried to keep this project really simple and just show some GenServers, ETS Tables, and Phoenix APis, so there are some improvements I could do, but I decided not to do:

  * Use Ecto / PostgreSQL / Ecto Transactions (Multi)
  * Use Ecto or Params to validate user inputs
  * Use individual security for each account
  * Not allow an account to access data of other accounts
  * Use back office as Admin of all accounts
  * Use Docker

### To start your Phoenix server:

    * Enter to the api folder `cd api`
    * Install dependencies with `mix deps.get`
    * Start Phoenix endpoint with `mix phx.server`

  Now you can make some requests to the API on `localhost:4000`

#### Authorization Basic
- username: backoffice
- password: backoffice

#### API's
- /api/v1/banking - Return all accounts
- /api/v1/banking/open/:email - Open a new account
- /api/v1/banking/info/:email - Get account info
- /api/v1/banking/transfer/:source_email/:destination_email/:amount - Transfer Money from source to destination
- /api/v1/banking/cash-out/:email/:amount - Cash Out from Account
- /api/v1/banking/report - Return all Transactions for day (sum), month, year
