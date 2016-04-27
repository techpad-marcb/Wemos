--------------------------------
--                            --
--  dht11 module for NodeMCU  --
--                            --
--------------------------------

local moduleName = ...
local M = {}
_G[moduleName] = M

local temp = 0
local hum = 0
local bitStream = {}

function M.init(pin)
  bitStream = {}
  for j = 1, 40, 1 do
    bitStream[j] = 0
  end
  bitlength = 0

  gpio.mode(pin,gpio.OUTPUT)
  gpio.write(pin,gpio.LOW)
  tmr.delay(20000)
  --Use Markus Gritsch trick to speed up read/write on GPIO
  gpio_read = gpio.read
  gpio_write = gpio.write

  gpio.mode(pin, gpio.INPUT)

  while (gpio_read(pin) == 0) do end

  c = 0
  while (gpio_read(pin) == 1 and c < 100) do c = c + 1 end

  while (gpio_read(pin) == 0) do end

  c = 0
  while (gpio_read(pin) == 1 and c < 100) do c = c + 1 end

  for j = 1, 40, 1 do
    while (gpio_read(pin) == 1 and bitlength < 10) do
      bitlength = bitlength + 1
    end
    bitStream[j] = bitlength
    bitlength = 0
    while (gpio_read(pin) == 0) do end
  end

  hum = 0
  temp = 0

  for i = 1, 8, 1 do
    if (bitStream[i + 0] > 2) then
      hum = hum + 2 ^ (8 - i)
    end
  end
  for i = 1, 8, 1 do
    if (bitStream[i + 16] > 2) then
      temp = temp + 2 ^ (8 - i)
    end
  end

  local byte_0 = 0
  local byte_1 = 0
  local byte_2 = 0
  local byte_3 = 0
  local byte_4 = 0

  for i = 1, 8, 1 do -- Byte 0
    if (bitStream[i] > 2) then
      byte_0 = byte_0 + 2 ^ (8 - i)
    end
  end

  for i = 1, 8, 1 do -- Byte 1
    if (bitStream[i+8] > 2) then
      byte_1 = byte_1 + 2 ^ (8 - i)
    end
  end

  for i = 1, 8, 1 do -- Byte 2
    if (bitStream[i+16] > 2) then
      byte_2 = byte_2 + 2 ^ (8 - i)
    end
  end

  for i = 1, 8, 1 do -- Byte 3
    if (bitStream[i+24] > 2) then
      byte_2 = byte_2 + 2 ^ (8 - i)
    end
  end

  for i = 1, 8, 1 do -- Byte 4
    if (bitStream[i+32] > 2) then
      byte_4 = byte_4 + 2 ^ (8 - i)
    end
  end

  if byte_1==0 and byte_3 == 0 then
    byte_5 = byte_0+byte_2
    if(byte_4 ~= byte_5) then
      hum = nil
      temp = nil
    else
      hum = byte_0 *10
      temp = byte_2 *10 
    end

  else
    hum = byte_0 * 256 + byte_1
    temp = byte_2 * 256 + byte_3
    checksum = byte_4

    checksumTest = (bit.band(hum, 0xFF) + bit.rshift(hum, 8) + bit.band(temp, 0xFF) + bit.rshift(temp, 8))
    checksumTest = bit.band(checksumTest, 0xFF)

    if temp > 0x8000 then
      temp = -(temp - 0x8000)
    end

    if (checksumTest - checksum >= 1) or (checksum - checksumTest >= 1) then
      hum = nil
    end

  end

  bitStream = {}
  gpio_read = nil
  gpio_write = nil
end

function M.getTemp()
  return temp
end

function M.getHumidity()
  return hum
end

return M
