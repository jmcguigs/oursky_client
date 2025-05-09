defmodule OurskyClient.Sda.SatelliteTarget do
  @moduledoc """
  Data structure for satellite targets
  """

  defstruct [
    :id,
    :norad_id,
    :name,
    :description,
    :area,
    :mass,
    :classification,
    :reflection_coefficient,
    :launch_year,
    :elset_number,
    :orbit_type,
    :mean_motion,
    :eccentricity,
    :inclination,
    :raan,
    :arg_of_perigee,
    :mean_anomaly,
    :epoch,
    :mean_motion_dot,
    :mean_motion_ddot,
    :bstar,
    :tle_line_1,
    :tle_line_2,
    :tracking_status,
    :linked_target_id,
    :rev_at_epoch
  ]

  @type t :: %__MODULE__{
          id: String.t(),
          norad_id: String.t(),
          name: String.t(),
          description: String.t(),
          area: float(),
          mass: float(),
          classification: String.t(),
          reflection_coefficient: float(),
          launch_year: integer(),
          elset_number: String.t(),
          orbit_type: String.t(),
          mean_motion: float(),
          eccentricity: float(),
          inclination: float(),
          raan: float(),
          arg_of_perigee: float(),
          mean_anomaly: float(),
          epoch: DateTime.t(),
          mean_motion_dot: float(),
          mean_motion_ddot: float(),
          bstar: float(),
          tle_line_1: String.t(),
          tle_line_2: String.t(),
          tracking_status: String.t(),
          linked_target_id: String.t(),
          rev_at_epoch: integer()
        }
end
