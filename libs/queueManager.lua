local module = {}
module.__index = module

local remove_error_format = 'Position "%s" does not exist in the queue.'

function module.new(guild)
    local queueObject = setmetatable({}, module)

    queueObject._queue = {}
    queueObject._player = guild.player
    queueObject._iterator = ipairs(queueObject._queue)

    return queueObject
end

function module:StartQueue()
    if self._playing then return end
    self._playing = true

    self:AdvanceQueue()
end

function module:AdvanceQueue()
    self.index, self.value = self._iterator(self._queue, self.index)

    local trackInfo = self.value
    local player = self._player

    player:play(trackInfo._queueTrack)

    player:on('end', function()
        print('test')
    end)
end

function module:Add(trackInfo)
    if not self._playing then
        self:StartQueue()
    end

    table.insert(self._queue, trackInfo)
end

function module:Remove(position)
    local queue = self._queue

    if not queue[position] then
        error(remove_error_format:format(position), 0)
    end

    table.remove(queue, position)
end

return module