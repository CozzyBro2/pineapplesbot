local filesystem = require('fs')

local discordia = require('discordia')
local lavalink = require('discordia-lavalink')

local slash = require('discordia-slash')
slash.constructor()

local client = discordia.Client()
client:useSlashCommands()

local command_require_format = 'commands/%s'

local lavalinkNodes = {
	{
        host = '127.0.0.1',
        port = 2333,
        password = 'polyphiagoatisagreatdemonstrationofguitarskill'
    }
}

client:on('slashCommandsReady', function()
    for _, name in ipairs(filesystem.readdirSync('libs/commands')) do
        local commandInfo = require(command_require_format:format(name))

        client:slashCommand(commandInfo)
    end
end)

client:on('ready', function()
    print('Logged in successfully')

    _G.voiceManager = lavalink.VoiceManager(client, lavalinkNodes)
end)

local token, err = filesystem.readFileSync('.SECRET')

if err then
    error(err, 0)
end

client:run("Bot " .. token)