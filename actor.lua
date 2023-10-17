--actor class
Actor = inherits(AnimatedSprite, {
    dx = 0, dy = 0,
    xr = 0, yr = 0,
    body = {}
})

local actor_mt = class(Actor)

function Actor:new(x, y, skins, opts)
    opts = opts or {}

    local o = AnimatedSprite:init(x, y, skins)
    o.type = opts.type or "static"

    local s = setmetatable(o, actor_mt)

    if opts.default then
        s:adddefaultbox()
    end

    return s
end

function Actor:add(x, y, skins, opts)
    table.insert(p, Actor:new(x, y, skins, opts))
end

--add a collision box to the actor with a specified width or height
--xoff/yoff define the box's position relative to the actor
function Actor:addbox(width, height, xoff, yoff)
    xoff = xoff or 0
    yoff = yoff or 0
    table.insert(self.body, Rectangle:new(self.x + xoff, self.y + yoff, width, height, xoff, yoff))
end

--add a collision box that is the size of the sprite
function Actor:adddefaultbox()
    self:addbox(self.width, self.height)
end

--check if this actor collides with another actor
--offset applies to the position of this actor
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

--check if this actor collides with the defined rectangle
--offset applies to the position of this actor
function Actor:collideswithrect(rect, offset)
    offset = offset or { x = 0, y = 0 }
    for _, box in pairs(self.body) do
        if box:collideswith(rect, offset) then
            return true
        end
    end
    return false
end

--update the position of this actor horizontally, checking for collisions every pixel
function Actor:movex(vel)
    --update subpixel by velocity, and round to a whole pixel
    self.xr = self.xr + vel
    local move = self.xr > 0 and math.floor(self.xr) or self.xr <= 0 and math.ceil(self.xr)

    --step forward one pixel at a time
    if math.abs(move) > 0 then
        local sign = self.xr > 0 and 1 or self.xr < 0 and -1
        self.xr = self.xr - move

        while move ~= 0 do
            --if the next step would cause a collision, halt velocity
            if self:collides({ x = sign, y = 0 }) then
                self.dx = 0
                self.xr = 0
                break
            end

            --otherwise, step forward and update this actor's collision
            self.x = self.x + sign
            move = move - sign
            self:updatebody()
        end
    end
end

--update the position of this actor vertically, checking for collisions every pixel
function Actor:movey(vel)
    --update subpixel by velocity, and round to a whole pixel
    self.yr = self.yr + vel
    local move = self.yr > 0 and math.floor(self.yr) or self.yr <= 0 and math.ceil(self.yr)

    --step forward one pixel at a time
    if math.abs(move) > 0 then
        local sign = self.yr > 0 and 1 or self.yr < 0 and -1
        self.yr = self.yr - move

        while move ~= 0 do
            --if the next step would cause a collision, halt velocity
            if self:collides({ x = 0, y = sign }) then
                self.dy = 0
                self.yr = 0
                break
            end
            
            --otherwise, step forward and update this actor's collision
            self.y = self.y + sign
            move = move - sign
            self:updatebody()
        end
    end
end

--update this actor's collision to this actor's (new) position
function Actor:updatebody()
    for _,box in pairs(self.body) do
        box.x = self.x + box.xoff
        box.y = self.y + box.yoff
    end
end

function Actor:applyphysics(dt)
    --calculate friction based on framerate, and apply
    local friction = 1 / (1 + (dt * physics.friction))
    self.dx = self.dx * friction

    --move self based on velocity
    self:movex(self.dx * dt * 100)
    self:movey(self.dy * dt * 100)

    --if self's velocity is very small, snap to 0
    if math.abs(self.dx) < 0.001 then self.dx = 0 end
    if math.abs(self.dy) < 0.001 then self.dy = 0 end

    --apply gravity
    self.dy = self.dy + dt * physics.gravity
end

function Actor:update(dt)
    if self.type == "dynamic" then
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