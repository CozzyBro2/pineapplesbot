local module = {}

local reply = require('discordia-replies').reply

local user_annoyances = {

    ["110920376619368448"] = {
        chance = 10,

        choices = {

            {isReaction = true, content = '💀'},
            {isReaction = true, content = '🤓'},

        }
    }, -- Break

    ["991846615675568128"] = {
        chance = 1,

        choices = {
            {content = 'shut up'},
            {content = "you're retarded"},
            {content = "fuck off dumbass"},
            {content = "im playing fortnite shut up"},
            {content = "breakon can go suck himself"},
        }
    }, -- BreakBot

    ["563331892997521429"] = {
        chance = 20,

        choices = {
            {isReaction = true, content = '👍'},
            {isReaction = true, content = '💖'},
            {isReaction = true, content = '✅'},
            {isReaction = true, content = '🥵️'},
            {isReaction = true, content = '👌'},
        }
    }, -- Elite engy

}

local content_annoyances = {

    gato = {content = 'gato? where?', chance = 30},
    fucking = {content = 'chill im scared', chance = 50},

    breakbot = {content = 'what a faggard', chance = 70},
    play = {content = 'IP: 10.0.0.1', chance = 40}

}

function module.tryAnnoy(message, guild)
    local id = message.author.id
    local messageContent = message.cleanContent

    local userAnnoyance = user_annoyances[id]

    for userId in pairs(message.mentionedUsers) do
        if userId == '1007455271968317481' then
            reply(message, 'FUCK OFF')

            break
        end
    end

    if userAnnoyance then
        local chance = userAnnoyance.chance

        if chance and math.random(0, 100) <= chance * guild.annoyingScale then
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

    for content, contentAnnoyance in pairs(content_annoyances) do
        local chance = contentAnnoyance.chance

        if messageContent:find(content) and chance and math.random(0, 100) <= chance * guild.annoyingScale then
            reply(message, contentAnnoyance.content)

            break
        end
    end
end

return module