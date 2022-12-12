local module = {}

local http = require('http')
local https = require('https')

local json = require('json')
local enums = require("discordia-slash").enums

--local api_format = 'https://api.mcsrvstat.us/2/%s'
local api_format = 'https://mcapi.us/server/status?ip=%s'
local uptime_format = 'Days: %d, Hours: %.2f'

local default_ip = 'mc.hashtheclass.xyz'
local default_field = 'not known'

module.name = 'server'
module.description = 'Checks on the status of the minecraft server'

module.type = enums.optionType.subCommand
module.dm_permission = false

module.options = {
    {
        name = 'ip',
        description = string.format("The ip to check (optional. default is: %s)", default_ip),
        type = enums.optionType.string,

        required = false,
    },
}

-- Darius, marc_s: Stack overflow
local function httpGET(url, callback)
    url = http.parseUrl(url)
    local req = (url.protocol == 'https' and https or http).get(url, function(res)
      local body={}
      res:on('data', function(s)
        body[#body+1] = s
      end)
      res:on('end', function()
        res.body = table.concat(body)
        callback(res)
      end)
      res:on('error', function(err)
        callback(res, err)
      end)
    end)
    req:on('error', function(err)
      callback(nil, err)
    end)
end

function module.callback(interaction, params)
    local ip = params.ip or default_ip

    if not ip then
        error("Invalid IP", 0)
    end

    local url = string.format(api_format, ip)

    print('Making a request to:', url)

    local function SendEmbed(data)
        local isOnline = not not data.online

        local uptime = data.duration
        local uptimeDays = tonumber(uptime) / 86400

        local serverInfo = data.server
        local playersInfo = data.players

        interaction:reply {
            embed = {
                title = ip,
                description = 'Here is information about that server:',
                url = url,
            
                fields = {
                    {
                        name = 'Is Online:',
                        value = isOnline
                    },

                    {
                        name = 'Version:',
                        value = serverInfo.name or default_field
                    },

                    {
                        name = 'Players Online:',
                        value = playersInfo.now or default_field
                    },

                    {
                        name = "Uptime (probably bogus):",
                        value = string.format(uptime_format, uptimeDays, (uptime / 3600) % 24)
                    }
       
                },

                author = {
                    name = 'Server Information',
                },

                --[[
                thumbnail = data.favicon and {
                    url = tostring(data.favicon),
                },
                --]]
            
                color = 0x00ff00,
            }
        }
    end

    httpGET(url, function(result, err)
        if err then
            error(err, 0)
        else
            local data = json.parse(result.body)

            coroutine.wrap(SendEmbed)(data)
        end
    end)
end

return module