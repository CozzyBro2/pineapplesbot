local module = {}

local enums = require("discordia-slash").enums
local guildManager = require("guildManager")

module.name = 'leave'
module.description = 'Leaves the current channel'

module.type = enums.optionType.subCommand
module.dm_permission = false

function module.callback(interaction)
    local guild = guildManager.new(interaction)
    local channel = interaction.guild.me.voiceChannel

    if not channel then
        interaction:reply("Dawg u aint in a channel", true)

        return
    end

    guild.inVoice = false
    guild.queue:Destroy()

    _G.voiceManager:leave(channel)

    interaction:reply("Sure buddy, tried to leave my current channel.")
end

return module