defmodule OurskyClient do
  @moduledoc """
  Documentation for `OurskyClient`.
  """

  @doc """
  Set access token for the client.

  ## Examples

      iex> OurskyClient.set_access_token("token")
      :ok

  """
  def set_access_token(token) do
    Application.put_env(:oursky_client, :access_token, token)
  end
end
