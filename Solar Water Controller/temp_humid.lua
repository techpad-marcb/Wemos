
-- set up some ky015 sensor
dht = require("ky015")
dhtpin = 4
dht.init(dhtpin)

t = dht.getTemp()
h = dht.getHumidity()

if h == nil then
  print("Error reading from ky-015")
else
  print(string.format("Temperature: %.1f deg C",t/10))
  print(string.format("Humidity: %.1f%%",h/10))
end
dht = nil
package.loaded["ky015"] = nil
