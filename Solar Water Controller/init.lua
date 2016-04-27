function startup()
    -- Connect to Network
    print('Wemos Started')
    print('Connecting to network ...')
    wifi.setmode(wifi.STATION)
    wifi.sta.connect()
    wifi.sta.setip({ip="192.168.0.153",netmask="255.255.255.0",gateway="192.168.0.254"})
    print("ESP8266 mode is: " .. wifi.getmode())
    print("The MAC address is: " .. wifi.ap.getmac())
    print("Weather Server IP: " .. wifi.sta.getip())

    --Setup OLED with u8glib lib
    sda = 2
    scl = 1
    sla = 0x3c
    i2c.setup(0, sda, scl, i2c.SLOW)
    disp = u8g.ssd1306_64x48_i2c(sla)
    disp:setFont(u8g.font_6x10)
    disp:setFontRefHeightExtendedText()
    disp:setDefaultForegroundColor()
    disp:setFontPosTop()
    
    dofile('weather.lua')
    tmr.alarm(0,2000,1,function()
            dofile('oled.lua') 
            end
            )
end        

print("\nInitially delaying for 10 seconds in case there is a bug somewhere in the main code ")
print("thus giving me a 10 sec window to fix things etc")
tmr.alarm(0,10000,0,startup)

