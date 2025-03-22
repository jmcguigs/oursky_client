defmodule OurskyClient.Sda.ObservationSequenceResult do
  @moduledoc """
  Struct for Observation Sequence Results

  format of observation sequence results from the API docs:

  [
  {
    "createdAt": "2025-03-22T02:58:08.977Z",
    "createdBy": "123e4567-e89b-12d3-a456-426614174000",
    "generatedTleLine1": "…",
    "generatedTleLine2": "…",
    "id": "123e4567-e89b-12d3-a456-426614174000",
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
    "noradId": "…",
    "targetId": "123e4567-e89b-12d3-a456-426614174000"
  }
  ]
  """

  alias OurskyClient.Sda.ImageSet

  defstruct [
    :created_at,
    :created_by,
    :generated_tle_line_1,
    :generated_tle_line_2,
    :id,
    :image_sets,
    :norad_id,
    :target_id
  ]

  @type t :: %__MODULE__{
          created_at: DateTime.t(),
          created_by: String.t(),
          generated_tle_line_1: String.t(),
          generated_tle_line_2: String.t(),
          id: String.t(),
          image_sets: [ImageSet.t()],
          norad_id: String.t(),
          target_id: String.t()
        }
end
