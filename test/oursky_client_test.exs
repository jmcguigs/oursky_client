defmodule OurskyClientTest do
  use ExUnit.Case
  doctest OurskyClient

  test "greets the world" do
    assert OurskyClient.hello() == :world
  end
end
