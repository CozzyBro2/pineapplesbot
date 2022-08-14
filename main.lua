local filesystem = require('fs')

local commandMap = require('commandMap')
local guildManager = require('guildManager')

local annoying = require('annoying')
local discordia = require('discordia')

local lavalink = require('discordia-lavalink')

local slash = require('discordia-slash')
slash.constructor()

local client = discordia.Client()
client:useSlashCommands()

local lavalinkNodes = {
	{
        host = '127.0.0.1',
        port = 2333,
        password = 'polyphiagoatisagreatdemonstrationofguitarskill'
    }
}

local client_id

client:on('slashCommandsReady', function()
    print('Readying slash commands...')

    for _, existingCommand in pairs(client:getSlashCommands()) do
        local name = existingCommand.name

        if not commandMap[name] then
            existingCommand:delete()

            print('discarding obsolete command: ' .. name)
        end
    end

    for _, command in pairs(commandMap) do
        local callback = command.callback

        command.callback = function(interaction, ...)
            local success, err = pcall(callback, interaction, ...)

            if not success then
                interaction:reply("Command errored, here's the error:\n" .. err)
            end
        end

        client:slashCommand(command)
    end

    print('Slash commands initialized & ready.')
end)

client:on('ready', function()
    print('Logged in successfully')

    client_id = client.user.id
    _G.voiceManager = lavalink.VoiceManager(client, lavalinkNodes)
end)

client:on('messageCreate', function(message)
    if message.author.id == client_id then return end

    local guild = guildManager.new(message)

    if guild.beAnnoying then
        annoying.tryAnnoy(message, guild)
    end
end)

local token, err = filesystem.readFileSync('.SECRET')

if err then
    error(err, 0)
end

client:run("Bot " .. token)