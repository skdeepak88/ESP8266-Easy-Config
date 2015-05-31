local httphelper = {}
local function jsonpost(host, uri, data)
	local request = "POST "..uri.." HTTP/1.1\r\n"..
	"Host: "..host.."\r\n"..
	"Connection: keep-alive\r\n"..
	"Content-Type: application/json\r\n"..
	"Content-Length: "..string.len(data).."\r\n"..
	"Accept: application/json\r\n"..
	"\r\n"..
	data
	return request
end
function httphelper.sendsensor_data(status)
	local postdata = "{\"status\":" .. status .. "}"
	local host = "dweet.io"
	local uri = "/dweet/for/youtthing"
	local socket = net.createConnection(net.TCP,0)
	socket:connect(80,host)
	socket:on("connection",function(sck)
		local postreq = jsonpost(host,uri,postdata)
		sck:send(postreq)
		sck:close()
		sck = nil
	end)
	socket:close()
	socket = nil
end
return httphelper
