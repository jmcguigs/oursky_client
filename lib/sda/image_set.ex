defmodule OurskyClient.Sda.ImageSet do
  @moduledoc """
  ImageSet struct for the SDA API

  format from SDA docs:
  "imageSets": [
    {
      "covariance": [
        [
          1
        ]
      ],
      "id": "123e4567-e89b-12d3-a456-426614174000",
      "nodeId": "123e4567-e89b-12d3-a456-426614174000",
      "observationQuality": {
        "distanceFromPredictionAverage": 1,
        "distanceFromPredictionLineFitSlope": 1,
        "distanceFromPredictionLineFitStdDev": 1,
        "lineFitOffsetStdDev": 1
      },
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
    }
  ],
  """

  alias OurskyClient.Sda.ObservationResult

  defstruct [
    :covariance,
    :id,
    :node_id,
    :observation_quality,
    :observation_results
  ]

  @type t :: %__MODULE__{
          covariance: list(),
          id: String.t(),
          node_id: String.t(),
          observation_quality: %{
            distance_from_prediction_average: float(),
            distance_from_prediction_line_fit_slope: float(),
            distance_from_prediction_line_fit_std_dev: float(),
            line_fit_offset_std_dev: float()
          },
          observation_results: list(ObservationResult.t())
        }
end
