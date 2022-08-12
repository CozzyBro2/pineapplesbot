local module = {}

local enums = require("discordia-slash").enums

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

function module.callback(interaction, params, command)
    local channel = params.channel

    if not channel then
        interaction:reply("Sure buddy, trying to join your voice channel", true)

        channel = interaction.member.voiceChannel
    else
        interaction:reply("Sure buddy, trying to join that channel", true)
    end

    _G.voiceManager:join(channel)
end

return module