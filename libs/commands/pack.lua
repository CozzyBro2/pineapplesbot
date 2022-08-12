local module = {}

local enums = require("discordia-slash").enums

module.name = 'pack'
module.description = 'Roast tf out of some poor soul (real)'

module.type = enums.optionType.subCommand
module.dm_permission = false

module.options = {
    {
        name = 'user',
        description = 'The user to pack',

        type = enums.optionType.user,
        required = true,
    }
}

local responses = {

    {format = '"%s".. bruh, what a retarded ass name'},
    {format = '"%s".. bruh, what a lame ass name'},

    {format = 'I once pistol whipped a fagio named %s'},

}

local responses_len = #responses

function module.callback(interaction, params)
    local response = responses[math.random(1, responses_len)]
    local format = response.format

    local output

    if type(format) == 'string' then
        output = string.format(format, params.user.name)
    elseif type(format) == 'function' then
        output = format(params.user) or 'i got nothin'
    end

    interaction:reply(output)
end

return module