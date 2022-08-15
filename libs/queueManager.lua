local module = {}
module.__index = module

local remove_error_format = 'Position "%s" does not exist in the queue.'

function module.new(guild)
    local queueObject = setmetatable({}, module)

    queueObject._queue = {}
    queueObject._player = guild.player

    return queueObject
end

function module:_StartQueue()
    if self._playing then return end
    self._playing = true

    self:_AdvanceQueue()
end

function module:_StopQueue()
    self._playing = false
    self._player:stop()
end

function module:_AdvanceQueue()
    self.index, self.value = next(self._queue, self.index)

    if not self.value then
        self:_StopQueue()

        return
    end

    local trackInfo = self.value
    local player = self._player

    player:play(trackInfo._queueTrack)

    player:on('end', function()
        if not self._playing then return end

        self:Remove(self.index)
        self:_AdvanceQueue()
    end)
end

function module:Add(trackInfo)
    table.insert(self._queue, trackInfo)

    if not self._playing then
        self:_StartQueue()
    end
end

function module:Remove(position)
    local queue = self._queue

    if not queue[position] then
        error(remove_error_format:format(position), 0)
    end

    table.remove(queue, position)
end

function module:Destroy()
    self:_StopQueue()

    setmetatable(self, nil)

    for key in pairs(self) do
        self[key] = nil
    end

    self = nil
end

return module