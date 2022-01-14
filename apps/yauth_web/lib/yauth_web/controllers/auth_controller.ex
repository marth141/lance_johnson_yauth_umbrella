defmodule YauthWeb.AuthController do
  use YauthWeb, :controller
  plug Ueberauth
  alias Yauth.Accounts
  alias YauthWeb.Authentication

  def request(conn, _params) do
    # PResent an authentication challenge to the user
  end

  def callback(%{assigns: %{ueberauth_auth: auth_data}} = conn, _params) do
    # Find the account if it exists or create it if it doesnt
    case Accounts.get_or_register(auth_data) do
      {:ok, account} ->
        conn
        |> Authentication.log_in(account)
        |> redirect(to: Routes.profile_path(conn, :show))

      {:error, _error_changeset} ->
        conn
        |> put_flash(:error, "Authentication failed.")
        |> redirect(to: Routes.registration_path(conn, :new))
    end
  end

  def callback(%{assigns: %{ueberauth_failure: _}} = conn, _params) do
    # Tell the user something went wrong
    conn
    |> put_flash(:error, "Authentication failed.")
    |> redirect(to: Routes.registration_path(conn, :new))
  end
end
