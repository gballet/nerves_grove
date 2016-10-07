# This is free and unencumbered software released into the public domain.

defmodule Nerves.Grove.LED do
  @moduledoc """
  Seeed Studio [Grove LED](http://wiki.seeedstudio.com/wiki/Grove_-_LED)

  # Example

      alias Nerves.Grove.LED

      {:ok, pid} = LED.start_link(pin)

      LED.blink(pid)
  """

  @i2c_read_command  1
  @i2c_write_command 2
  @i2c_mode_command  5

  @spec start_link(pos_integer) :: {:ok, pid} | {:error, any}
  def start_link(pin) when is_integer(pin) do
    pins = Application.get_env(:nerves_grove, :pins, [])
    { _, type, extra } = Enum.find(pins, fn {pn,backend} -> pn == pin end) || {pin, :gpio}

    case type do
      :gpio ->
        {success, pid} = Gpio.start_link(pin, :output)
        {success, {pid, :gpio, pin}}
      :i2c ->
        { fname, address } = extra
        with {:ok, pid} <- I2c.start_link(fname, address),
             :ok <- I2c.write(pid, <<@i2c_mode_command, pin, 1, 0>>),
           do: {:ok, {pid, :i2c, pin}}
    end    
  end

  @doc "Blinks the LED for a specified duration."
  @spec blink(pid, number) :: any
  def blink(pid, duration \\ 0.2) when is_pid(pid) and is_number(duration) do
    duration_in_ms = duration * 1000 |> round
    on(pid)
    :timer.sleep(duration_in_ms)
    off(pid)
  end

  @doc "Switches on the LED."
  @spec on({pid,Keyword.T,pos_integer}) :: any
  def on(data) when is_tuple(data) do
    {pid, type, pin} = data
    case type do
      :gpio -> Gpio.write(pid, 1)
      :i2c  -> I2c.write(pid, <<@i2c_write_command, pin, 1, 0>>)
      _     -> {:error, "Invalid line type"}
    end
  end

  @doc "Switches off the LED."
  @spec off({pid, Keyword.T, pos_integer}) :: any
  def off(data) when is_tuple(data) do
    {pid, type, pin} = data
    case type do
      :gpio -> Gpio.write(pin, 1)
      :i2c  -> I2c.write(pid, <<@i2c_write_command, pin, 0, 0>>)
      _     -> {:error, "Invalid line type"}
    end
  end
end
