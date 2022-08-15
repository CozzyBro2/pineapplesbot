-- HashCollision 08/15/22
-- A module to allow the bot maintainer with shell access to cleanly shut down the bot.

local module = {}

local prompt = require('prompt') {}
local cliFunctions = {}

function cliFunctions.q()
    _G.botClient:stop()
    _G.botDisabled = true

    os.exit(0)
end

function module.init()
    while not _G.botDisabled do
        local input = prompt('Give the bot a command (q to exit)')
        local callback = cliFunctions[input]

        if callback then
            callback()
        end
    end
end

cliFunctions.exit = cliFunctions.q
cliFunctions.quit = cliFunctions.quit

return module