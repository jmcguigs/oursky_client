defmodule OurskyClient.Sda.ObservationResult do
  @moduledoc """
  format from docs:

  "observationResults": [
        {
          "apparentMagnitude": 1,
          "astrometricOffsets": {
            "decPlateSolveOffsetAverage": 1,
            "decPlateSolveOffsetStdDev": 1,
            "fwhmAverage": 1,
            "fwhmStdDev": 1,
            "raPlateSolveOffsetAverage": 1,
            "raPlateSolveOffsetStdDev": 1
          },
          "boundingBox": {
            "endX": 1,
            "endY": 1,
            "startX": 1,
            "startY": 1
          },
          "correctedDec": 1,
          "correctedRa": 1,
          "dec": 1,
          "distanceFromPrediction": 1,
          "features": [
            {
              "apparentMagnitude": 1,
              "boundingBox": {
                "endX": 1,
                "endY": 1,
                "startX": 1,
                "startY": 1
              },
              "correctedDec": 1,
              "correctedRa": 1,
              "dec": 1,
              "distanceFromPrediction": 1,
              "ra": 1,
              "targetCorrelations": [
                {
                  "angleFromStreak": 1,
                  "dec": 1,
                  "distanceFromStreak": 1,
                  "ra": 1,
                  "streakLength": 1,
                  "targetId": "123e4567-e89b-12d3-a456-426614174000"
                }
              ],
              "timestamp": "2025-03-22T02:58:08.977Z"
            }
          ],
          "geolat": 1,
          "geolon": 1,
          "imageId": "123e4567-e89b-12d3-a456-426614174000",
          "imageUrl": "…",
          "jpgUrl": "…",
          "ra": 1,
          "solarEqPhaseAngle": 1,
          "solarPhaseAngle": 1,
          "timestamp": "2025-03-22T02:58:08.977Z",
          "timingAccuracy": 1
        }
      ]
  """

  defstruct [
    :apparent_magnitude,
    :astrometric_offsets,
    :bounding_box,
    :corrected_dec,
    :corrected_ra,
    :dec,
    :distance_from_prediction,
    :features,
    :geolat,
    :geolon,
    :image_id,
    :image_url,
    :jpg_url,
    :ra,
    :solar_eq_phase_angle,
    :solar_phase_angle,
    :timestamp,
    :timing_accuracy
  ]

  @type t :: %__MODULE__{
          apparent_magnitude: float(),
          astrometric_offsets: %{
            dec_plate_solve_offset_average: float(),
            dec_plate_solve_offset_std_dev: float(),
            fwhm_average: float(),
            fwhm_std_dev: float(),
            ra_plate_solve_offset_average: float(),
            ra_plate_solve_offset_std_dev: float()
          },
          bounding_box: %{
            end_x: integer(),
            end_y: integer(),
            start_x: integer(),
            start_y: integer()
          },
          corrected_dec: float(),
          corrected_ra: float(),
          dec: float(),
          distance_from_prediction: float(),
          features: list(map()),
          geolat: float(),
          geolon: float(),
          image_id: String.t(),
          image_url: String.t(),
          jpg_url: String.t(),
          ra: float(),
          solar_eq_phase_angle: float(),
          solar_phase_angle: float(),
          timestamp: DateTime.t(),
          timing_accuracy: integer()
        }
end
