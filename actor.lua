Actor = inherits(AnimatedSprite, {
    dx = 0, dy = 0,
    xr = 0, yr = 0,
    body = {}
})

local actor_mt = class(Actor)

function Actor:new(x, y, skins)
    local o = AnimatedSprite:init(x, y, skins)

    local s = setmetatable(o, actor_mt)

    s:adddefaultbox()

    return s
end

function Actor:add(x, y, skins)
    table.insert(p, Actor:new(x, y, skins))
end

function Actor:addbox(w, h, xoff, yoff)
    table.insert(self.body, Rectangle:new(self.x + (xoff or 0), self.y + (yoff or 0), w, h, xoff or 0, yoff or 0))
end

function Actor:adddefaultbox()
    self:addbox(self.w, self.h)
end

function Actor:movex(vel)
    self.xr = self.xr + vel
    local move = self.xr > 0 and math.floor(self.xr) or self.xr <= 0 and math.ceil(self.xr)
    if move > 0 then
        local sign = self.xr > 0 and 1 or self.xr < 0 and -1
        self.xr = self.xr - move

        while move ~= 0 do
            self.x = self.x + move
            move = move - sign
            self:updatebody()
        end
    end
end

function Actor:movey(vel)
    self.yr = self.yr + vel
    local move = self.yr > 0 and math.floor(self.yr) or self.yr <= 0 and math.ceil(self.yr)
    if move > 0 then
        local sign = self.yr > 0 and 1 or self.yr < 0 and -1
        self.yr = self.yr - move

        while move ~= 0 do
            self.y = self.y + move
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

function Actor:update(dt)
    self:animate(dt)
end

function Actor:draw()
    self:drawselfanim()
    if love.keyboard.isDown("right") then
        self:movex(1)
    end

    if showdebug then
        for _,box in pairs(self.body) do
            box:draw()
        end
    end
end