defmodule OurskyClient.Sda do
  @moduledoc """
  Client for the OurSky SDA API https://api.prod.oursky.ai/docs/sda
  """
  alias OurskyClient.Sda.SatelliteTarget
  alias OurskyClient.Sda.OrganizationTarget
  alias OurskyClient.Sda.Node
  alias OurskyClient.Sda.ObservationSequenceResult
  alias OurskyClient.Sda.ObservationResult
  alias OurskyClient.Sda.ImageSet

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

  @doc """
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
    response =
      Req.get!("https://api.prod.oursky.ai/v1/satellite-targets?noradId=" <> norad_id,
        auth: {:bearer, Application.get_env(:oursky_client, :access_token)}
      )

    case response.status do
      200 ->
        {:ok,
         for target <- response.body["targets"] do
           parse_satellite_target(target)
         end}

      _ ->
        {:error, response.body}
    end
  end

  @doc """
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
    response =
      "https://api.prod.oursky.ai/v1/organization-target"
      |> Req.post!(
        json: %{
          satelliteTargetId: oursky_target_uuid
        },
        auth: {:bearer, Application.get_env(:oursky_client, :access_token)}
      )

    case response.status do
      200 ->
        {:ok, created_at, 0} = DateTime.from_iso8601(response.body["createdAt"])

        {:ok,
         %OrganizationTarget{
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

  @doc """
  Untask a target given its UUID.

  ## Examples

      iex> OurskyClient.Sda.untask_target("c0baf754-4561-4219-a559-03f648c1208e")
      {:ok, %{"id" => "333afd5e-9b4e-4811-8a18-fde7b2604fce}}
  """
  def untask_target(oursky_target_uuid) do
    response =
      ("https://api.prod.oursky.ai/v1/organization-target?satelliteTargetId=" <>
         oursky_target_uuid)
      |> Req.delete!(auth: {:bearer, Application.get_env(:oursky_client, :access_token)})

    case response.status do
      200 ->
        {:ok, response.body}

      _ ->
        {:error, response.body}
    end
  end

  @doc """
  Get node properties given a node's UUID (found in observation sequence results)

  ## Examples
      iex> OurskyClient.Sda.get_node_properties("3be53422-5c54-413c-9a54-2a8e73c0ed27")
      {:ok,
      %OurskyClient.Sda.Node{
        id: "3be53422-5c54-413c-9a54-2a8e73c0ed27",
        gps_timestamps: false,
        location: %{latitude: 52.200239, longitude: 6.857524, altitude: 30.0},
        mount_type: "EQUITORIAL",
        ota_aperture_mm: 207,
        ota_focal_length_mm: 831,
        pixel_size_microns: 4.78,
        focuser_travel_distance_mm: nil,
        shutter_type: "ROLLING",
        megapixels: 16.236096
      }}
  """
  def get_node_properties(node_uuid) do
    response =
      Req.get!("https://api.prod.oursky.ai/v1/node-properties?nodeId=#{node_uuid}",
        auth: {:bearer, Application.get_env(:oursky_client, :access_token)}
      )

    case response.status do
      200 ->
        {:ok,
         %Node{
           id: node_uuid,
           gps_timestamps: response.body["gpsTimestamps"],
           location: %{
             latitude: response.body["location"]["latitude"],
             longitude: response.body["location"]["longitude"],
             altitude: response.body["location"]["altitude"]
           },
           mount_type: response.body["mountType"],
           ota_aperture_mm: response.body["otaApertureMm"],
           ota_focal_length_mm: response.body["otaFocalLengthMm"],
           pixel_size_microns: response.body["pixelSizeMicrons"],
           focuser_travel_distance_mm: response.body["focuserTravelDistanceMm"],
           shutter_type: response.body["shutterType"],
           megapixels: response.body["megapixels"]
         }}

      _ ->
        {:error, response.body}
    end
  end

  defp parse_observation_sequence_result(osr) do
    {:ok, created_at, 0} = DateTime.from_iso8601(osr["createdAt"])

    %ObservationSequenceResult{
      id: osr["id"],
      created_at: created_at,
      created_by: osr["createdBy"],
      generated_tle_line_1: osr["generatedTleLine1"],
      generated_tle_line_2: osr["generatedTleLine2"],
      image_sets: for(image_set <- osr["imageSets"]) do
        %ImageSet{
          id: image_set["id"],
          node_id: image_set["nodeId"],
          observation_results: for(observation_result <- image_set["observationResults"]) do
            {:ok, timestamp, 0} = DateTime.from_iso8601(observation_result["timestamp"])
            %ObservationResult{
              apparent_magnitude: observation_result["apparentMagnitude"],
              astrometric_offsets: observation_result["astrometricOffsets"],
              bounding_box: observation_result["boundingBox"],
              corrected_dec: observation_result["correctedDec"],
              corrected_ra: observation_result["correctedRa"],
              dec: observation_result["dec"],
              distance_from_prediction: observation_result["distanceFromPrediction"],
              features: observation_result["features"],
              geolat: image_set["geolat"],
              geolon: image_set["geolon"],
              image_id: image_set["imageId"],
              image_url: image_set["imageUrl"],
              jpg_url: image_set["jpgUrl"],
              ra: observation_result["ra"],
              solar_eq_phase_angle: observation_result["solarEqPhaseAngle"],
              solar_phase_angle: observation_result["solarPhaseAngle"],
              timestamp: timestamp,
              timing_accuracy: observation_result["timingAccuracy"],
            }
          end
        }
      end,
      norad_id: osr["noradId"],
      target_id: osr["targetId"]
    }
  end

  @doc """
  Get observation sequence results for a given target UUID
   - If you intend to receive many observations, set up webhooks on the API console.

  ## Parameters
  - `target_uuid`: The UUID of the target
  - `min_epoch`: The minimum epoch to filter results
  - `max_pages`: The maximum number of pages to retrieve (default: 100)

  ## Examples

      iex> OurskyClient.Sda.get_observation_sequence_results("c0baf754-4561-4219-a559-03f648c1208e", "2025-03-21T00:00:00Z")
      {:ok, [%OurskyClient.Sda.ObservationSequenceResult{...}]}
  """
  def get_observation_sequence_results(target_uuid, min_epoch, max_pages \\ 100) do
    get_all_observation_sequence_results(target_uuid, min_epoch, [], max_pages)
  end

  defp get_all_observation_sequence_results(target_uuid, after_param, acc_results, max_pages, current_page \\ 1) do
    # Build URL with after parameter if it exists
    url = if after_param do
      "https://api.prod.oursky.ai/v1/observation-sequence-results?targetId=#{target_uuid}&after=#{after_param}"
    else
      "https://api.prod.oursky.ai/v1/observation-sequence-results?targetId=#{target_uuid}"
    end

    response =
      Req.get!(url,
        auth: {:bearer, Application.get_env(:oursky_client, :access_token)}
      )

    case response.status do
      200 ->
        osrs = response.body
        parsed_results = for osr <- osrs, do: parse_observation_sequence_result(osr)
        all_results = acc_results ++ parsed_results

        # Stop if we've reached the maximum number of pages or if we got no results
        if current_page >= max_pages or osrs == [] do
          {:ok, all_results}
        else
          # Extract the createdAt from the last raw result to use as the after parameter
          last_osr = List.last(osrs)
          last_created_at = last_osr["createdAt"]
          # Recursively get the next page
          get_all_observation_sequence_results(target_uuid, last_created_at, all_results, max_pages, current_page + 1)
        end
      _ ->
        {:error, response.body}
    end
  end

  @doc """
  Create a custom target for your organization using a two-line element set (TLE)

  ## Parameters
  - `tle_line_1`: The first line of the TLE
  - `tle_line_2`: The second line of the TLE
  - `name`: The name of the target

  ## Options
  - `:mass` - Mass in kg (default: 100.0)
  - `:area` - Cross-sectional area in square meters (default: 1.0)
  - `:reflection_coefficient` - Reflection coefficient (default: 0.2)
  - `:linked_target_id` - UUID of linked target (default: nil)

  ## Examples

      iex> OurskyClient.Sda.create_target(
      ...>   "1 25544U 98067A   25080.55743056  .00026289  00000-0  47116-3 0  9999",
      ...>   "2 25544  51.6381  21.0488 0004053  35.5022 296.1249 15.49747147501567",
      ...>   "ISS (ZARYA)",
      ...>   mass: 420000.0,
      ...>   area: 160.0
      ...> )
      {:ok, "6e801835-4aae-4b78-9741-f10fbab472db"}
  """
def create_target(tle_line_1, tle_line_2, name, opts \\ []) do
  # use reasonable default AMR value typical of satellite payloads
  mass = Keyword.get(opts, :mass, 100.0)
  area = Keyword.get(opts, :area, 1.0)
  reflection_coefficient = Keyword.get(opts, :reflection_coefficient, 0.2)
  linked_target_id = Keyword.get(opts, :linked_target_id)

  response =
    "https://api.prod.oursky.ai/v1/satellite-target"
    |> Req.post!(
      json: %{
        tleLine1: tle_line_1,
        tleLine2: tle_line_2,
        tleName: name,
        mass: mass,
        area: area,
        reflectionCoefficient: reflection_coefficient,
        linkedSatelliteTargetId: linked_target_id
      },
      auth: {:bearer, Application.get_env(:oursky_client, :access_token)}
    )

  case response.status do
    200 ->
      {:ok, response.body["id"]}
    _ ->
      {:error, response.body}
    end
  end

  @doc """
  PUT request to update a target's TLE
  """
  def update_target(target_uuid, tle_line_1, tle_line_2, name, opts \\ []) do
    # use reasonable default AMR value typical of satellite payloads
    mass = Keyword.get(opts, :mass, 100.0)
    area = Keyword.get(opts, :area, 1.0)
    reflection_coefficient = Keyword.get(opts, :reflection_coefficient, 0.2)

    response =
      "https://api.prod.oursky.ai/v1/satellite-target/"
      |> Req.put!(
        json: %{
          targetId: target_uuid,
          tleLine1: tle_line_1,
          tleLine2: tle_line_2,
          tleName: name,
          mass: mass,
          area: area,
          reflectionCoefficient: reflection_coefficient
        },
        auth: {:bearer, Application.get_env(:oursky_client, :access_token)}
      )

    case response.status do
      200 ->
        {:ok, response.body}
      _ ->
        {:error, response.body}
    end
  end
end
