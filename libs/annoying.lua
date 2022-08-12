local module = {}

local reply = require('discordia-replies').reply

local user_annoyances = {

    ["110920376619368448"] = {
        chance = 8,

        choices = {

            {isReaction = true, content = '💀'},
            {isReaction = true, content = '🤓'},

            {content = 'malding?'},
            {content = 'bruh'},
            {content = 'garbage take'},
            {content = 'your bot sucks'},
            {content = 'you suck'},

        }
    }, -- Break
    ["325106358460612608"] = {
        choices = {
            {isReaction = true, content = ''}
        }
    }, -- Hash
    ["991846615675568128"] = {
        choices = {
            
        }
    }, -- BreakBot
    ["1005429077332729856"] = {
        choices = {
            
        }
    }, -- Gato bot
    ["563331892997521429"] = {
        chance = 40,

        choices = {
            {isReaction = true, content = '👍'},
            {isReaction = true, content = '💖'},
            {isReaction = true, content = '✅'},
            {isReaction = true, content = '🥵️'},
            {isReaction = true, content = '👌'},

            {content = 'love you babe..'},
            {content = 'yeaj,,..'},
        }
    }, -- Elite engy

}

local content_annoyances = {



}

function module.tryAnnoy(message, guild)
    local id = message.author.id
    local userAnnoyance = user_annoyances[id]

    for userId in pairs(message.mentionedUsers) do
        if userId == '1007455271968317481' then
            reply(message, 'FUCK OFF')

            break
        end
    end

    if userAnnoyance then
        local chance = userAnnoyance.chance

        if chance and math.random(0, 100) < chance * guild.annoyingScale then
            local choices = userAnnoyance.choices
            local choice = choices[math.random(1, #choices)]

            if choice then
                if choice.isReaction then
                    message:addReaction(choice.content)
                else
                    reply(message, choice.content:format(message.author.name))
                end
            end
        end
    end
end

return module