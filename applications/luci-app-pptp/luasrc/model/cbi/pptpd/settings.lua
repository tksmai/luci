m = Map("pptpd")

s = m:section(TypedSection, "service", translate("VPN Server: General settings"))
s.anonymous = true

o = s:option(Flag, "enabled", translate("Enable VPN Server"))
o.rmempty = false
function o.write(self, section, value)
	if value == "1" then
		luci.sys.init.enable("pptpd")
		luci.sys.call("/etc/init.d/pptpd start >/dev/null")
	else
		luci.sys.call("/etc/init.d/pptpd stop >/dev/null")
		luci.sys.init.disable("pptpd")
	end
	return Flag.write(self, section, value)
end

o = s:option(Value, "localip", translate("Server IP"), translate("VPN Server IP address, it not required."))
o.datatype = "ipaddr"
o.placeholder = translate("192.168.0.1")
o.rmempty = true
o.default = ""

o = s:option(Value, "remoteip", translate("Client IP"), translate("VPN Client IP address, it not required."))
o.placeholder = translate("192.168.0.2-254")
o.rmempty = true
o.default = ""

o = s:option(DynamicList, "dns", translate("DNS IP address"), translate("This will be sent to the client, it not required."))
o.placeholder = translate("8.8.8.8")
o.datatype = "ipaddr"
--[[
function o.write(self, section, value)
	luci.sys.call("echo xiaopiao $value  >> /tmp/xiaopiao")
end
]]--

o = s:option(Flag, "mppe", translate("Enable MPPE Encryption"), translate("Allows 128-bit encrypted connection."))
o.rmempty = false

o = s:option(Flag, "nat", translate("Enable NAT Forward"), translate("Allows forwarding traffic."))
o.rmempty = false

o = s:option(Flag, "internet", translate("Enable remote service"), translate("Allows remote computers on the Internet to connect to VPN Server."))
o.rmempty = false

return m
