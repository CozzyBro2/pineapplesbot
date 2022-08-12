local module = {}

local enums = require("discordia-slash").enums

module.name = 'ping'
module.description = 'Replies with pong. and also about how long the command took to run.'

module.type = enums.optionType.subCommand
module.dm_permission = true

local ping_format = 'Pong! Took %.2fms to reply.'

function module.callback(interaction, params)
    local currentTime = os.time()
    local sentTime = interaction.createdAt

    local timeTaken = (currentTime - sentTime)

    interaction:reply(ping_format:format(timeTaken * 1000))
end

return module
