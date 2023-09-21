--trigger class
Trigger = inherits(Rectangle, {
    activator = "player",
    action = function() end
})

function Trigger:update(dt)
    for _, sprite in pairs(p) do
        if sprite.user ~= nil then
            if sprite.user == self.activator then
                if sprite:collideswithrect(self) then
                    self:action()
                end
            end
        end
    end
end

function Trigger:draw()
    if showdebug then Rectangle.draw(self, { r = 1, g = 1, b = 1 }, "line") end
end

--camlock trigger class
CameraLockTrigger = inherits(Trigger, {
    
})

local camera_lock_trigger_mt = class(CameraLockTrigger)

function CameraLockTrigger:new(x, y, w, h, xlock, ylock)
    local o = Rectangle:init(x, y, w, h)
    o.xlock = xlock or false
    o.ylock = ylock or false

    o.action = function()
        camera.xlock = o.xlock
        camera.ylock = o.ylock
    end

    local s = setmetatable(o, camera_lock_trigger_mt)
    return s
end

function CameraLockTrigger:add(x, y, w, h, xlock, ylock)
    table.insert(p, CameraLockTrigger:new(x, y, w, h, xlock, ylock))
end