local filesystem = require('fs')
local discordia = require('discordia')

local slash = require('discordia-slash')
slash.constructor()

local client = discordia.Client()
client:useSlashCommands()

local command_require_format = 'commands/%s'

client:on('slashCommandsReady', function()
    for _, name in ipairs(filesystem.readdirSync('libs/commands')) do
        local commandInfo = require(command_require_format:format(name))

        client:slashCommand(commandInfo)
    end
end)

local token, err = filesystem.readFileSync('.SECRET')

if err then
    error(err, 0)
end

client:run("Bot " .. token)