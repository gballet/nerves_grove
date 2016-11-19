# This is free and unencumbered software released into the public domain.

defmodule Nerves.Grove.NFC do
  @moduledoc """
  Seeed Studio Grove NFC reader

  # Example

      alias Nerves.Grove.NFC

      {:ok, pid} = NFC.start_link(address)

      NFC.read_eeprom(size)
  """

  @default_nfc_address 0x53


  @spec start_link(pos_integer) :: {:ok, pid} | :error
  def start_link(address = @default_nfc_address) do
    I2c.start_link("i2c-1", address)
  end

  @doc "Read the content of the EEPROM"
  @spec read_eeprom(pid, 0..512) :: any
  def read_eeprom(pid, size) do
    I2c.read(pid, size)
  end
end
