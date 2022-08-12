local module = {}

local enums = require("discordia-slash").enums

module.name = 'leave'
module.description = 'Leaves the current channel'

module.type = enums.optionType.subCommand
module.dm_permission = false

function module.callback(interaction)
    local channel = interaction.guild.me.voiceChannel

    if not channel then
        interaction:reply("Dawg u aint in a channel", true)
    else
        interaction:reply("Sure buddy, leaving my current channel", true)
    end

    _G.voiceManager:leave(channel)
end

return module