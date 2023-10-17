Player = inherits(Actor)
local player_mt = class(Player)

function Player:new(x, y, skins, opts)
    opts = opts or {}

    local o = Actor:init(x, y, skins)
    o.type = "dynamic"

    local s = setmetatable(o, player_mt)

    if opts.default then
        s:adddefaultbox()
    end

    return s
end

function Player:add(x, y, skins, opts)
    table.insert(p, Player:new(x, y, skins, opts))
end

function Player:update(dt)
    if love.keyboard.isDown("right") then
        self.dx = self.dx + dt * 100
        self.flipped = false
    end
    if love.keyboard.isDown("left") then
        self.dx = self.dx - dt * 100
        self.flipped = true
    end
    if love.keyboard.isDown("up") and self:collides({ x = 0, y = 0.01 }) then
        self.dy = -20
    end
    
    self:applyphysics(dt)
    self:animate(dt)
end