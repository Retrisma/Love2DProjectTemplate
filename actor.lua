Actor = inherits(AnimatedSprite, {
    dx = 0, dy = 0,
    xr = 0, yr = 0
})

local actor_mt = class(Actor)

function Actor:new(x, y, skins)
    local o = AnimatedSprite:init(x, y, skins)

    return setmetatable(o, actor_mt)
end

function Actor:add(x, y, skins)
    table.insert(p, Actor:new(x, y, skins))
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
        end
    end
end

function Actor:update(dt)
    self:animate(dt)
    self:movex(100 * dt)
end