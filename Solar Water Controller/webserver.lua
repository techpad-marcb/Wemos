-- Start Server
srv=net.createServer(net.TCP, 4)
srv:listen(80,function(conn)
    conn:on("receive",function(conn,request)
    print(request)

    if h == nil then
      print("Error reading from ky-015")
    else
      print(string.format("Temperature: %.1f deg C",t/10))
      print(string.format("Humidity: %.1f%%",h/10))
    end
    
        if string.match(request, "machine") then
            if h == nil then
                -- Do nothing
            end
            if t == nil then
                -- Do Nothing
            end
            conn:send(string.format("Temperature: %.1f ",t/10).."&deg;C, "..string.format("Humidity: %.1f%%",h/10))
            
        else
            if h == nil then
                -- Do Nothing
            end
            if t == nil then
                -- Do Nothing
            end
            conn:send([[
                     <html><head><title>Office</title>
                     <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">
                     <meta http-equiv="refresh" content="30" />
                     </head>                       
                     <body><center>
                     <table class="table">
                     <tr><td><font size="2"><center>Temperature</center></font></td></tr>
                     <tr><td><font size="7"><center>]]..string.format("%.1f ",t/10)..[[&deg;C</center></font></td></tr>                
                     <tr><td><font size="2"><center>Humidity</center></font></td></tr>
                     <tr><td><font size="5"><center>]]..string.format("%.1f%%",h/10)..[[</center></font></td></tr>                
                     </table>
                     <button type="button" class="btn btn-primary">Refresh</button>
                     </center></body></html>
                     ]])
        end
    
    dht = nil
    package.loaded["ky015"] = nil
    end)
end)
