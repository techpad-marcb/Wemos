--print("Refresh OLED")
-- Set DHT sensor
dht = require("ky015")
dhtpin = 4
dht.init(dhtpin)

disp:firstPage()
repeat
-- Get Values
tt = dht.getTemp()
ht = dht.getHumidity()
if ht == nil then
    h = 0
else
    h = ht
end
if tt == nil then
    t = 0
else
    t = tt
end    
disp:drawStr(0,0,"ServerIP") -- Starting on line 0
disp:drawStr(0,11,wifi.sta.getip())
disp:drawStr(0,22,"Temp: "..string.format("%f ",t/10))
disp:drawStr(0,33,"Humid: "..string.format("%f%%",h/10))
until disp:nextPage() == false
