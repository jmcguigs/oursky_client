defmodule OurskyClient.Sda.OrganizationTarget do
  @moduledoc """
  Data structure for organization targets
  """
  defstruct [
    :created_at,
    :created_by,
    :id,
    :revisit_rate_minutes,
    :satellite_target,
  ]

  @type t :: %__MODULE__{
    created_at: DateTime.t(),
    created_by: String.t(),
    id: String.t(),
    revisit_rate_minutes: integer(),
    satellite_target: OurskyClient.Sda.SatelliteTarget.t(),
  }
end
