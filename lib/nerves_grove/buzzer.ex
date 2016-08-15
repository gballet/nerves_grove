# This is free and unencumbered software released into the public domain.

defmodule Nerves.Grove.Buzzer do
  @moduledoc """
  http://wiki.seeedstudio.com/wiki/Grove_-_Buzzer
  """

  @spec start_link(pos_integer) :: {:ok, pid} | {:error, any}
  def start_link(pin) do
    Gpio.start_link(pin, :output)
  end

  @doc "Beeps the buzzer."
  @spec beep(pid, number) :: any
  def beep(pid, duration \\ 0.1) do
    duration_in_ms = duration * 1000 |> round
    on(pid)
    :timer.sleep(duration_in_ms)
    off(pid)
  end

  @doc "Turns on the buzzer."
  @spec on(pid) :: any
  def on(pid) do
    Gpio.write(pid, 1)
  end

  @doc "Turns off the buzzer."
  @spec off(pid) :: any
  def off(pid) do
    Gpio.write(pid, 0)
  end
end
