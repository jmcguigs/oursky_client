defmodule OurskyClient.Sda.Node do
  @moduledoc """
  Node struct for the SDA API
  """

  defstruct [
    :id,
    :gps_timestamps,
    :location,
    :mount_type,
    :ota_aperture_mm,
    :ota_focal_length_mm,
    :pixel_size_microns,
    :focuser_travel_distance_mm,
    :shutter_type,
    :megapixels
  ]

  @type t :: %__MODULE__{
          id: String.t(),
          gps_timestamps: boolean(),
          location: %{
            latitude: float(),
            longitude: float(),
            altitude: float()
          },
          mount_type: String.t(),
          ota_aperture_mm: float(),
          ota_focal_length_mm: float(),
          pixel_size_microns: float(),
          focuser_travel_distance_mm: float(),
          shutter_type: String.t(),
          megapixels: float()
        }
end
