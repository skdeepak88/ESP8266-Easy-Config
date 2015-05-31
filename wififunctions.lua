local wifihelper = {}
function wifihelper.check_wifi()
	if wifi.sta.getip() == nil then
		pwm.setduty(2,512)
		return false
	else
		pwm.setduty(2,0)
		return true
	end
end
local function establish_connection()
	if tmr.now() > 30000000 then
		wifi.setmode(wifi.SOFTAP)
		local cfg={}
		cfg.ssid="ESPSensor"
		cfg.pwd="opendoor"
		wifi.ap.config(cfg)
		tmr.stop(0)
	end
	if wifihelper.check_wifi() then
		tmr.stop(0)
	end
end
function wifihelper.connect_wifi(ssid, pass)
	file.open("wifipass.txt", 'w')
	file.write("ssid=" .. ssid .. "&pass=" .. pass)
	file.close()
	wifi.setmode(wifi.STATIONAP)
	wifi.sta.config(ssid, pass)
	tmr.alarm(0,2000,1,establish_connection)
end
function wifihelper.setup_wifi()
	if wifihelper.check_wifi() then
		return true
	end
	file.open("wifipass.txt", 'r')
	local details=file.read()
	file.close()
	if details then
		local lssid=string.match(details,"ssid=%s*(%w+)")
		local lpass=string.match(details,"pass=%s*(%w+)")
		if lssid and lpass then
			wifihelper.connect_wifi(lssid, lpass)
		end
	end
end
return wifihelper
