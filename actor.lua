Actor = inherits(AnimatedSprite, {
    dx = 0, dy = 0,
    xr = 0, yr = 0,
    body = {}
})

local actor_mt = class(Actor)

function Actor:new(x, y, skins, args)
    args = args or {}

    local o = AnimatedSprite:init(x, y, skins)
    o.type = args.type or "static"

    local s = setmetatable(o, actor_mt)

    if args.default then
        s:adddefaultbox()
    end

    return s
end

function Actor:add(x, y, skins, args)
    table.insert(p, Actor:new(x, y, skins, args))
end

function Actor:addbox(w, h, xoff, yoff)
    xoff = xoff or 0
    yoff = yoff or 0
    table.insert(self.body, Rectangle:new(self.x + xoff, self.y + yoff, w, h, xoff, yoff))
end

function Actor:adddefaultbox()
    self:addbox(self.w, self.h)
end

function Actor:collides(offset)
    offset = offset or { x = 0, y = 0 }
    for _, box in pairs(self.body) do
        for _, sprite in pairs(p) do
            if self ~= sprite and sprite.body ~= nil then
                for _, fix in pairs(sprite.body) do
                    if box:collideswith(fix, offset) then
                        return true
                    end
                end
            end
        end
    end
    return false
end

function Actor:movex(vel)
    self.xr = self.xr + vel
    local move = self.xr > 0 and math.floor(self.xr) or self.xr <= 0 and math.ceil(self.xr)
    if math.abs(move) > 0 then
        local sign = self.xr > 0 and 1 or self.xr < 0 and -1
        self.xr = self.xr - move

        while move ~= 0 do
            if self:collides({ x = sign, y = 0 }) then
                self.dx = 0
                self.xr = 0
                break
            end
            self.x = self.x + sign
            move = move - sign
            self:updatebody()
        end
    end
end

function Actor:movey(vel)
    self.yr = self.yr + vel
    local move = self.yr > 0 and math.floor(self.yr) or self.yr <= 0 and math.ceil(self.yr)
    if math.abs(move) > 0 then
        local sign = self.yr > 0 and 1 or self.yr < 0 and -1
        self.yr = self.yr - move

        while move ~= 0 do
            if self:collides({ x = 0, y = sign }) then
                self.dy = 0
                self.yr = 0
                break
            end
            self.y = self.y + sign
            move = move - sign
            self:updatebody()
        end
    end
end

function Actor:updatebody()
    for _,box in pairs(self.body) do
        box.x = self.x + box.xoff
        box.y = self.y + box.yoff
    end
end

function Actor:applyphysics(dt)
    local friction = 1 / (1 + (dt * 20))
    self.dx = self.dx * friction
    --self.dy = self.dy * friction

    self:movex(self.dx * dt * 100)
    self:movey(self.dy * dt * 100)

    if math.abs(self.dx) < 0.001 then self.dx = 0 end
    if math.abs(self.dy) < 0.001 then self.dy = 0 end

    self.dy = self.dy + dt * 100
end

function Actor:update(dt)
    if self.type == "dynamic" then
        if love.keyboard.isDown("right") then self.dx = self.dx + dt * 100 end
        if love.keyboard.isDown("left") then self.dx = self.dx - dt * 100 end
        if love.keyboard.isDown("up") and self:collides({ x = 0, y = 0.01 }) then self.dy = -20 end

        self:applyphysics(dt)
    end
    self:animate(dt)
end

function Actor:draw()
    self:drawselfanim()

    if showdebug then
        for _,box in pairs(self.body) do
            local color = { r = 0, g = 0, b = 0 }
            if self.type == "static" then color.b = 1
            elseif self.type == "dynamic" then color.r = 1 end
            box:draw(color)
        end
    end
end