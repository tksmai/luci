--[[
LuCI - Lua Configuration Interface

Copyright 2008 Steven Barth <steven@midlink.org>
Copyright 2008 Jo-Philipp Wich <xm@leipzig.freifunk.net>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

$Id: samba.lua 6984 2011-04-13 15:14:42Z soma $
]]--

m = Map("samba", translate("Network Shares"))

s = m:section(TypedSection, "samba", "Samba")
s.anonymous = true

s:tab("general",  translate("General Settings"))
s:tab("template", translate("Edit Template"))

s:taboption("general", Flag, "enabled", translate("Enable"))
s:taboption("general", Value, "name", translate("Hostname"))
s:taboption("general", Value, "description", translate("Description"))
s:taboption("general", Value, "workgroup", translate("Workgroup"))
s:taboption("general", Flag, "uenabled", translate("uenable"), translate("uenabled"))
u = s:taboption("general", Value, "user", translate("user"))
u:depends("uenabled", "1")
p = s:taboption("general", Value, "password", translate("password"))
p:depends("uenabled", "1")
p.password = true

tmpl = s:taboption("template", Value, "_tmpl",
	translate("Edit the template that is used for generating the samba configuration."), 
	translate("This is the content of the file '/etc/samba/smb.conf.template' from which your samba configuration will be generated. " ..
		"Values enclosed by pipe symbols ('|') should not be changed. They get their values from the 'General Settings' tab."))

tmpl.template = "cbi/tvalue"
tmpl.rows = 20

function tmpl.cfgvalue(self, section)
	return nixio.fs.readfile("/etc/samba/smb.conf.template")
end

function tmpl.write(self, section, value)
	value = value:gsub("\r\n?", "\n")
	nixio.fs.writefile("//etc/samba/smb.conf.template", value)
end


s = m:section(TypedSection, "sambashare", translate("Shared Directories"))
s.anonymous = true
s.addremove = true

s:option(Value, "name", translate("Name"))
pth = s:option(Value, "path", translate("Path"))
pth.rmempty = false
local pth_suggestions = nixio.fs.glob("/mnt/sd*")

if pth_suggestions then
	local node
	for node in pth_suggestions do
		pth:value(node)
	end
end

ro = s:option(Flag, "read_only", translate("Read-only"))
ro.rmempty = false
ro.enabled = "yes"
ro.disabled = "no"

go = s:option(Flag, "guest_ok", translate("Allow guests"))
go.rmempty = false
go.enabled = "yes"
go.disabled = "no"

return m

