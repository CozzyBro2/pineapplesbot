local module = {}

local enums = require("discordia-slash").enums
local guildManager = require('guildManager')

module.name = 'join'
module.description = 'Joins the specified voice channel. If ommitted, joins your channel.'

module.type = enums.optionType.subCommand
module.dm_permission = false

module.options = {
    {
        name = 'channel',
        description = "The channel to join (optional)",
        type = enums.optionType.channel,

        required = false,
    },
}

function module.callback(interaction, params)
    local guild = guildManager.new(interaction)
    local channel = params.channel or interaction.member.voiceChannel or interaction.guild:getChannel(guild.defaultVoice)

    if channel then
        interaction:reply('Sure buddy, trying to join your voice channel...', true)
    else
        interaction:reply("Couldn't find that channel, or you're not in one.", true)

        return
    end

    _G.voiceManager:join(channel)
end

return module