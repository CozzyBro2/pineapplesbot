local module = {}

local enums = require("discordia-slash").enums
local guildManager = require('guildManager')

local search_format = '%s:%s'

module.name = 'play'
module.description = "Add stuff to queue"

module.type = enums.optionType.subCommand
module.dm_permission = false

module.options = {
    {
        name = 'song',
        description = 'The song in question',
        type = enums.optionType.string,

        required = true,
    },

    {
        name = 'searcher',
        description = 'What to search for the audio with. Common ones are: ytsearch, scsearch',
        type = enums.optionType.string,

        required = false,
    }
}

function module.callback(interaction, params)
    local guild = guildManager.new(interaction)
    local queue = guild.queue

    if not guild.inVoice then
        error("I'm not in a voice channel.", 0)
    end

    local rawQuery = params.song
    local searcher = params.searcher or 'ytsearch'

    local query = search_format:format(searcher, rawQuery)
    local trackInfo = _G.voiceManager.api:get(query)

    if trackInfo then
        local tracks = trackInfo.tracks

        if tracks and #tracks > 0 then
            trackInfo._queueTrack = tracks[1].track

            queue:Add(trackInfo)
        else
            error(string.format("No results for '**%s**'", rawQuery), 0)
        end
    else
        error("Failed to fetch any API results, couldn't tell you why.", 0)
    end
end

return module