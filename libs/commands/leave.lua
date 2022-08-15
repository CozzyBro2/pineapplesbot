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
        error("Dawg u aint in a channel", 0)
    end

    guild.inVoice = false

    -- in the event the bot was in the vc and join wasn't called (i.e bot powercycle)
    if guild.queue then
        guild.queue:Destroy()
    end

    _G.voiceManager:leave(channel)
    interaction:reply('Tried leaving my voice channel.')
end

return module