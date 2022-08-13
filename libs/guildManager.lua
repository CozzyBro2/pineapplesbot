local module = {}
module.__index = module

local queueManager = require('queueManager')

local guild_settings = {
    default = {
        beAnnoying = false,
        annoyingScale = 1,
    },

    ["892450181809844275"] = {
        beAnnoying = true,

        defaultVoice = "1004199380334682183",
    },
}

local guilds = {}

local function copy(input, output)
    for key, value in pairs(input) do
        output[key] = value
    end
end

function module.new(interaction)
    local guildId = interaction.guild.id
    local existing = guilds[guildId]

    if existing then
        return existing
    end

    local guild = setmetatable({}, module)
    local overrides = guild_settings[tostring(guildId)]

    copy(guild_settings.default, guild)

    if overrides then
        copy(overrides, guild)
    end

    guild.queue = queueManager.new(guild)

    guilds[guildId] = guild
    return guild
end

return module