local module = {}

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

local function HandleError(err)
    print(err)

    error("Encountered error when making request.", 0)
end

function module.callback(interaction, params)
    local ip = params.ip or default_ip

    if not ip then
        error("Invalid IP", 0)
    end

    local url = string.format(api_format, ip)

    local request = https.get(url, function(result)
        result:on('data', function(str)
            local data = json.parse(str)

            local isOnline = not not data.online

            local uptime = data.duration
            local uptimeDays = tonumber(uptime) / 86400

            local serverInfo = data.server
            local playersInfo = data.players

            coroutine.resume(coroutine.create(function()
                interaction:reply {
                    embed = {
                        title = ip,
                        description = 'Here is information about that server:',
                        url = url,
            
                        fields = {
                            {
                                name = 'Is Online:',
                                value = isOnline or default_field
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

                        thumbnail = data.favicon and {
                            url = tostring(data.favicon),
                        },
            
                        color = 0x00ff00,
                    }
                }
            end))
        end)

        result:on('error', HandleError)
    end)

    request:on('error', HandleError)
end

return module