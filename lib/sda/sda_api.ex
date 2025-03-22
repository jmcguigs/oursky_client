defmodule OurskyClient.Sda do
  @moduledoc """
  Client for the OurSky SDA API https://api.prod.oursky.ai/docs/sda
  """
  alias OurskyClient.Sda.SatelliteTarget
  alias OurskyClient.Sda.OrganizationTarget

  defp parse_satellite_target(target) do
    {:ok, epoch, 0} = DateTime.from_iso8601(target["tleEpoch"])
    %SatelliteTarget{
      id: target["id"],
      norad_id: target["noradId"],
      name: target["tleName"],
      description: target["description"],
      area: target["area"],
      mass: target["mass"],
      classification: target["classification"],
      reflection_coefficient: target["reflectionCoefficient"],
      launch_year: target["launchYear"],
      elset_number: target["elsetNumber"],
      orbit_type: target["orbitType"],
      mean_motion: target["meanMotion"],
      eccentricity: target["eccentricity"],
      inclination: target["inclination"],
      raan: target["raan"],
      arg_of_perigee: target["perigeeArgument"],
      mean_anomaly: target["meanAnomaly"],
      epoch: epoch,
      mean_motion_dot: target["meanMotionDerivative"],
      mean_motion_ddot: target["meanMotionSecondDerivative"],
      bstar: target["bstar"],
      tle_line_1: target["tleLine1"],
      tle_line_2: target["tleLine2"],
      tracking_status: target["trackingStatus"],
      linked_target_id: target["linkedSatelliteTargetId"],
      rev_at_epoch: target["revolutionNumberAtEpoch"]
    }
  end

  @doc"""
  Get target information for a given NORAD ID

  ## Examples

      iex> OurskyClient.Sda.get_targets_by_norad_id("25544")
      {:ok,
      [
        %OurskyClient.Sda.SatelliteTarget{
          id: "6e801835-4aae-4b78-9741-f10fbab472db",
          norad_id: "25544",
          name: "ISS (ZARYA)",
          description: nil,
          area: 160.273,
          mass: 20351.0,
          classification: "U",
          reflection_coefficient: nil,
          launch_year: 1998,
          elset_number: nil,
          orbit_type: "LEO",
          mean_motion: 15.497471470000002,
          eccentricity: 4.053e-4,
          inclination: 51.6381,
          raan: 21.0488,
          arg_of_perigee: 35.5022,
          mean_anomaly: 296.1249,
          epoch: ~U[2025-03-21 13:22:42Z],
          mean_motion_dot: nil,
          mean_motion_ddot: 0.0,
          bstar: 0.0,
          tle_line_1: "1 25544U 98067A   25080.55743056  .00026289  00000-0  47116-3 0  9999",
          tle_line_2: "2 25544  51.6381  21.0488 0004053  35.5022 296.1249 15.49747147501567",
          tracking_status: "ACTIVE",
          linked_target_id: nil,
          rev_at_epoch: 50156
        }
      ]}
  """
  def get_targets_by_norad_id(norad_id) do
    response = Req.get!("https://api.prod.oursky.ai/v1/satellite-targets?noradId=" <> norad_id, auth: {:bearer, Application.get_env(:oursky_client, :access_token)})
    case response.status do
      200 ->
        {:ok, for target <- response.body["targets"] do
          parse_satellite_target(target)
        end}
      _ ->
        {:error, response.body}
    end
  end

  @doc"""
  Task a target to be observed given a UUID (OurSky uses immutable UUIDs for each target- these can be retrieved using the get_targets_by_norad_id function)

  Returns an `OrganizationTarget` (`SatelliteTarget` + tasking information)

  ## Examples

      iex> OurskyClient.Sda.task_observations_on_target("c0baf754-4561-4219-a559-03f648c1208e")
      {:ok,
      %OurskyClient.Sda.OrganizationTarget{
        created_at: ~U[2025-03-21 23:25:50.445716Z],
        created_by: "e745dbf8-b910-4ea1-ab87-440821ac9480",
        id: "333afd5e-9b4e-4811-8a18-fde7b2604fce",
        revisit_rate_minutes: nil,
        satellite_target: %OurskyClient.Sda.SatelliteTarget{
          id: "c0baf754-4561-4219-a559-03f648c1208e",
          norad_id: "41937",
          name: "SBIRS GEO 4 (USA 273)",
          description: nil,
          area: 33.213,
          mass: nil,
          classification: "U",
          reflection_coefficient: nil,
          launch_year: 2017,
          elset_number: nil,
          orbit_type: "EGO",
          mean_motion: 0.9999522199999998,
          eccentricity: 2.276e-4,
          inclination: 1.5423,
          raan: 21.6811,
          arg_of_perigee: 329.5307,
          mean_anomaly: 172.5673,
          epoch: ~U[2025-03-21 09:49:38.672Z],
          mean_motion_dot: nil,
          mean_motion_ddot: 0.0,
          bstar: 0.0,
          tle_line_1: "1 41937U 17004A   25080.40947537  .00000107  00000-0  00000-0 0  9998",
          tle_line_2: "2 41937   1.5423  21.6811 0002276 329.5307 172.5673  0.99995222 30063",
          tracking_status: "ACTIVE",
          linked_target_id: nil,
          rev_at_epoch: 3006
        }
      }}
  """
  def task_observations_on_target(oursky_target_uuid) do
    response = "https://api.prod.oursky.ai/v1/organization-target"
      |> Req.post!(json: %{
        satelliteTargetId: oursky_target_uuid,
      }, auth: {:bearer, Application.get_env(:oursky_client, :access_token)})

    case response.status do
      200 ->
        {:ok, created_at, 0} = DateTime.from_iso8601(response.body["createdAt"])
        {:ok, %OrganizationTarget{
          created_at: created_at,
          created_by: response.body["createdBy"],
          id: response.body["id"],
          revisit_rate_minutes: response.body["revisitRateMinutes"],
          satellite_target: parse_satellite_target(response.body["satelliteTarget"])
        }}
      _ ->
        {:error, response.body}
    end
  end

  @doc"""
  Untask a target given its UUID.

  ## Examples

      iex> OurskyClient.Sda.untask_target("c0baf754-4561-4219-a559-03f648c1208e")
      {:ok, %{"id" => "333afd5e-9b4e-4811-8a18-fde7b2604fce}}
  """
  def untask_target(oursky_target_uuid) do
    response = "https://api.prod.oursky.ai/v1/organization-target?satelliteTargetId=" <> oursky_target_uuid
      |> Req.delete!(auth: {:bearer, Application.get_env(:oursky_client, :access_token)})
    case response.status do
      200 ->
        {:ok, response.body}
      _ ->
        {:error, response.body}
    end
  end
end
