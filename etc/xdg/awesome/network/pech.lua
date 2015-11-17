local io = io
local math = math
local naughty = require("naughty")
local beautiful = require("beautiful")
local tonumber = tonumber
local tostring = tostring
local print = print
local pairs = pairs
local string = require("string")
local table = require("table")

-- These are essentially constants, but they contain the commands the shell
-- needs to run to manage all the network interfaces. Also, I need to buy
-- a couple extra batteries for this thing once I get libreboot ported.
local COMMAND_LIST_IFACE_STATES = "nmcli device"
local COMMAND_LIST_WIFIS = "nmcli device wifi"
local COMMAND_WIFI_CONNECT = "connect-wrapper"
--local COMMAND_WIFI_CONNECT = "nmcli device wifi connect"
local COMMAND_CHECK_WIFILIST_EXISTS = ""
local COMMAND_CAT_GPG_CIPHERTEXT = ""
local COMMAND_DECIPHER_GPG_NETPASSWDS = ""

module("netmgr")

terminal = "x-terminal-emulator"

function get_program_output(const)
    local handle = io.popen(const)
    local result = handle:read('*all')
    handle:close()
    return result
end

function sanitize_program_output(input)
    --This function doesn't do anything yet, but I'd hate to neglect it if it's
    --necessary, so I'm putting it here at the top and since I'm sure I won't
    --finish this tonight while I'm playing monopoly and drinking heavily, aka
    --saying yes to life, then I'll revisit it when I get the chance.
    return input
end

function arrayfy_by_newline(input)
    --This turns the output of a command into a table by splitting it along the
    --newlines.
    local sep = "\n"
    local t = {};
    for str in string.gmatch(input, "([^"..sep.."]+)") do
        if string.match(str,"\*") then
        else
        table.insert(t, str)
        end
    end
    return t
end

function arrayfy_by_whitespace(input)
    --This turns the output of a command into a table by splitting it along the
    --whitespace.
    local sep = "\n"
    local t = {};
    for str in input:gmatch("%S+") do
        table.insert(t, str)
    end
    return t
end

function get_local_interfaces()
    --Make a table of the local interfaces
    local result_nmed_ifaces = sanitize_program_output(get_program_output(COMMAND_LIST_IFACE_STATES))
    local result_array = arrayfy_by_newline(result_nmed_ifaces)
    return result_array
end

function get_area_wifi()
    --make a table of the scanned wifis
    local result_wifi_scan = sanitize_program_output(get_program_output(COMMAND_LIST_WIFIS))
    local result_array = arrayfy_by_newline(result_wifi_scan)
--    naughty.notify({title = "⚡ Wi-Fi ⚡",
--        text = "scanning nearby wifi\n" .. result_wifi_scan,
--        timeout = 2,
--        position = "top_right",
--        fg = beautiful.fg_focus,
--        bg = beautiful.bg_focus
--        })
    return result_array
end

function command_connect_wifi_network(clistring)
    sanitize_program_output(get_program_output(COMMAND_WIFI_CONNECT .. " " .. clistring))
    get_area_wifi()
end

function generate_network_menu()
    --generate the network menu
    local networks = {}
    local wifi_list = {}
    for key, iface in pairs(get_local_interfaces()) do
        if string.match(iface, "wifi") then
            for key, nwork in pairs(get_area_wifi()) do
                w = arrayfy_by_whitespace(nwork)
                work = {nwork, terminal .. " -e " .. COMMAND_WIFI_CONNECT .. " " .. w[1] }
--                work = {nwork, command_connect_wifi_network(w[1]) }
--		    naughty.notify({title = "⚡ Wi-Fi ⚡",
--			text = nwork .. terminal .. " -e " .. COMMAND_WIFI_CONNECT .. " " .. w[1],
--			timeout = 50,
--			position = "bottom_right",
--			fg = beautiful.fg_focus,
--			bg = beautiful.bg_focus
--			})
                table.insert(wifi_list, work)
            end
            ud = {"Toggle Wireless Interface On/Off", " -e sudo /usr/bin/iface-wrapper " .. iface}
            table.insert(wifi_list, ud)
            face = {iface, wifi_list}
            table.insert(networks, face)
        elseif string.match(iface, "DEVICE  TYPE      STATE        CONNECTION") then
            face = {iface, terminal .. " -e " .. COMMAND_LIST_WIFIS}
            table.insert(networks, face)
        else
            face = {iface, " -e sudo /usr/bin/iface-wrapper " .. iface}
            table.insert(networks, face)
        end
    end
    return networks
end

