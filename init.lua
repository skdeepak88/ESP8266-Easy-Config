pwm.setup(1,500,512)
pwm.setup(2,500,512)
pwm.setup(4,500,512)
pwm.start(1)
pwm.start(2)
pwm.start(4)
pwm.setduty(1,0)
pwm.setduty(2,0)
pwm.setduty(4,0)
local lwifi = require 'wififunctions'
lwifi.setup_wifi()
tmr.alarm(1,1000,1,function()
	local wifistatus = lwifi.check_wifi()
	if wifistatus then
		tmr.stop(1)
		local lhttp = require 'httpfunctions'
		print("Sensor activated")
		gpio.mode(7, gpio.INT)
		gpio.trig(7, "both", function(level)
			lwifi.setup_wifi()
			lhttp.sendsensor_data(level)
		end)
	end
end)

if srv then
	srv:close()
end
srv=net.createServer(net.TCP, 3)
srv:listen(80,function(conn)
	conn:on("receive", function(conn,payload)
		local isopen=false
		conn:on("sent", function(conn)
			if not isopen then
				isopen=true
				file.open('esptoy.htm', 'r')
			end
			local data=file.read(1024)
			if data then
				conn:send(data)
			else
				file.close()
				conn:close()
				conn=nil
			end
		end)
		if string.sub(payload, 1, 8) == 'GET /st?' then
			local lssid=string.match(payload,"ssid=%s*(%w+)")
			local lpass=string.match(payload,"pass=%s*(%w+)")
			if lssid then
				lwifi.connect_wifi(lssid, lpass)
			end
		elseif string.sub(payload, 1, 6) ~= 'GET / ' then
			conn:close()
		end
		conn:send("HTTP/1.1 200 OK\r\n")
		conn:send("Content-type: text/html\r\n")
		conn:send("Connection: close\r\n\r\n")
	end)
end)
