defmodule YelpEx.API do
  @moduledoc """
  Provides functionality to interact with the Yelp API.

  https://www.yelp.com/developers/documentation/v3
  """

  use HTTPoison.Base
  alias OAuth2

  @api_url "https://api.yelp.com/v3/"

  @client OAuth2.Client.new([
      strategy: OAuth2.Strategy.ClientCredentials,
      client_id: System.get_env("CLIENT_ID"),
      client_secret: System.get_env("CLIENT_SECRET"),
      site: "https://api.yelp.com",
      token_url: "/oauth2/token"
  ])

  @doc """
  Create a client with credentials to
  interact with the Yelp API server.
  """
  @spec create_client(String.t, String.t, Keyword.t) :: OAuth2.Client.t
  def create_client(client_id, client_secret, options \\ []) do
    OAuth2.Client.new([
      strategy: OAuth2.Strategy.ClientCredentials,
      client_id: client_id,
      client_secret: client_secret,
      site: "https://api.yelp.com",
      token_url: "/oauth2/token"
    ])
  end

  @doc """
  Get a Yelp API access token.

  `get_token/0` uses the default @client
  that was created using environment variables.

  `get_token/1` takes any %OAuth2.Client{}
  struct as an input. This should be created
  by using `create_client/2`.

  Returns %OAuth2.AccessToken{}.
  """
  @spec get_token(OAuth2.Client.t, Keyword.t) :: {:ok, OAuth2.Client.t} | {:error, HTTPoison.Error.t}
  def get_token(client \\ @client, options \\ []) do
    params = [
      grant_type: "client_credentials",
      client_id: client.client_id,
      client_secret: client.client_secret
    ]

    case OAuth2.Client.get_token(client, params) do
      {:ok, response} -> {:ok, response.token}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Same as `get_token`, but raises `HTTPoison.Error`
  if an error occurs during the request.
  """
  @spec get_token!(OAuth2.Client.t, Keyword.t) :: OAuth2.Client.t
  def get_token!(client \\ @client, options \\ []) do
    case get_token(client) do
      {:ok, token} -> token
      {:error, error} -> raise error
    end
  end

  @doc """
  Refreshes a Yelp API access token.
  """
  def refresh_token do
    :not_implemented
  end

  @doc """
  Perform an HTTP request.
  """
  @spec request(atom, String.t, body, headers, Keyword.t) :: {:ok, OAuth2.Response.t} | {:error, HTTPoison.Error.t}
  def request(method, endpoint, body \\ "", headers, options \\ []) do
    url = @api_url <> endpoint <> "?"

    super(method, url, "", headers, options)
  end

  @doc """
  Same as `request/5`, but returns `OAuth2.Response` or raises an error.
  """
  @spec request!(atom, String.t, body, headers, Keyword.t) :: OAuth2.Response.t
  def request!(method, url, body \\ "", headers \\ [], options \\ []) do
    case request(method, url, body, headers, options) do
      {:ok, response} -> response
      {:error, error} -> raise error
    end
  end

end