--button class
Button = inherits(AnimatedSprite, {
    state = 1,
    drawmode = "absolute"
})
local button_mt = class(Button)

function Button:init(x, y, anim, action)
    local o = {
        x = x,
        y = y,
        anim = animations[anim],
        action = action
    }

    o.bounds = Rectangle:new(o.x, o.y, o.anim.width, o.anim.height)

    return o
end

function Button:new(x, y, anim, action)
    return setmetatable(Button:init(x, y, anim, action), button_mt)
end

function Button:add(x, y, anim, action)
    table.insert(p, Button:new(x, y, anim, action))
end

function Button:update(dt)
    if self.bounds:containspoint(mouse.x, mouse.y, self.drawmode) then
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

--textbox class
Textbox = {
    bank = "",
    speed = 0.01, --delay in seconds per letter
    cooldown = 0,
    pixels = 0,
    pause = 0
}
local textbox_mt = class(Textbox)

function Textbox:init(x, y, text, opts)
    opts = opts or {}
    local o = {
        x = x, y = y,
        text = "",
        drawmode = "absolute"
    }

    for k,v in pairs(opts) do
        o[k] = v
    end

    if o.scroll then o.bank = text else o.text = text end

    local word = o.bank:match("(%w+)(.+)")
    local wordsize = fonts["ElixiR"]:getWidth(" " .. (word or ""))
    o.pixels = wordsize

    o.width = o.width or (o.image and o.image:getWidth()) or 100

    return o
end

function Textbox:new(x, y, text, opts)
    return setmetatable(Textbox:init(x, y, text, opts), textbox_mt)
end

function Textbox:add(x, y, text, opts)
    table.insert(p, Textbox:new(x, y, text, opts))
end

function Textbox:update(dt)
    if self.pause > 0 then
        self.pause = self.pause - dt
        return
    else
        self.pause = 0
    end

    if self.bank ~= "" then
        self.cooldown = self.cooldown + dt
        if self.cooldown > self.speed then
            self:nextletter()
            
            self.cooldown = self.cooldown - self.speed
        end
    end
end

function Textbox:nextletter()
    local char = self.bank:sub(1, 1)

    if char == " " then
        local word = self.bank:match("(%w+)(.+)")
        local wordsize = fonts["ElixiR"]:getWidth(" " .. (word or ""))

        if self.pixels + wordsize > self.width - (self.hpad * 2) then
            self.text = self.text .. "\n"
            self.pixels = 0
            char = ""
        end
        self.pixels = self.pixels + wordsize
    elseif char == "," then
        self.pause = 0.05
    elseif char == "." or char == "?" or char == "!" then
        self.pause = 0.2
    end

    self.text = self.text .. char
    self.bank = self.bank:sub(2)
end

function Textbox:draw()
    local textpos = {
        x = self.x + (self.hpad or 0),
        y = self.y + (self.vpad or 0)
    }

    if self.font then love.graphics.setFont(self.font) end

    if self.image then
        love.graphics.draw(self.image, self.x, self.y)
    end
    if self.shadow then
        love.graphics.setColor(self.shadow)
        love.graphics.print(self.text, textpos.x + 1, textpos.y + 1, 0)
        love.graphics.setColor(1, 1, 1, 1)
    end
    love.graphics.print(self.text, textpos.x, textpos.y, 0)
end