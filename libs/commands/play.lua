local module = {}

local luv = require('uv')
local parse = require('url').parse

local enums = require("discordia-slash").enums
local guildManager = require('guildManager')

local search_format = '%s:%s'
local audio_fetched_format = "Added **'%s'** to the queue, took **%.2f**s"

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
    if not interaction.guild.me.voiceChannel then
        require('commands/join').callback(interaction, params)
    end

    local guild = guildManager.new(interaction)
    local queue = guild.queue

    local startTime = luv.hrtime()

    local rawQuery = params.song
    local searcher = params.searcher or 'ytsearch'

    local query = rawQuery

    if not parse(rawQuery).protocol then
        query = search_format:format(searcher, rawQuery)
    end

    local tracksInfo = _G.voiceManager.api:get(query)

    if tracksInfo then
        local tracks = tracksInfo.tracks

        if tracks and #tracks > 0 then
            local track = tracks[1]
            local info = track.info

            tracksInfo._queueTrack = track.track
            queue:Add(tracksInfo)

            local timeTaken = (luv.hrtime() - startTime) / 1e9

            interaction:reply(audio_fetched_format:format(info.title, timeTaken))
        else
            error(string.format("No results for '**%s**'", rawQuery), 0)
        end
    else
        error("Failed to fetch any API results, couldn't tell you why.", 0)
    end
end

return module