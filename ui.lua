--button class
Button = inherits(AnimatedSprite, {
    state = 1
})
local button_mt = class(Button)

function Button:init(x, y, anim, action)
    local o = {
        x = x,
        y = y,
        anim = animations[anim],
        action = action
    }

    o.bounds = Rectangle:new(o.x, o.y, o.anim.w, o.anim.h)

    return o
end

function Button:new(x, y, anim, action)
    return setmetatable(Button:init(x, y, anim, action), button_mt)
end

function Button:add(x, y, anim, action)
    table.insert(p, Button:new(x, y, anim, action))
end

function Button:update(dt)
    if self.bounds:containspoint(mouse.x, mouse.y) then
        self.state = 2
        if mouse.p or mouse.held then
            self.state = 3
            if mouse.p then self:action() end
        end
    else
        self.state = 1
    end
    self:animate(dt)
end

function Button:animate(dt)
    self.frame = self.state
end