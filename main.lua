local filesystem = require('fs')

local annoying = require('annoying')
local guildManager = require('guildManager')

local discordia = require('discordia')
local lavalink = require('discordia-lavalink')

local slash = require('discordia-slash')
slash.constructor()

local client = discordia.Client()
client:useSlashCommands()

local command_require_format = 'commands/%s'
local client_id

local lavalinkNodes = {
	{
        host = '127.0.0.1',
        port = 2333,
        password = 'polyphiagoatisagreatdemonstrationofguitarskill'
    }
}

client:on('slashCommandsReady', function()
    print('Readying slash commands...')

    for _, name in ipairs(filesystem.readdirSync('libs/commands')) do
        local commandInfo = require(command_require_format:format(name))

        client:slashCommand(commandInfo)
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