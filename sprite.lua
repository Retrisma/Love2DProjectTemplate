--sprite class
Sprite = {
    r = 0,
    flipped = false
}
local sprite_mt = class(Sprite)

function Sprite:init(x, y, image)
    local o = {
        x = x, y = y,
        image = images[image]
    }
    o.w = o.image:getWidth()
    o.h = o.image:getHeight()

    return o
end

function Sprite:new(x, y, image)
    local o = Sprite:init(x, y, image)

    return setmetatable(o, sprite_mt)
end

function Sprite:add(x, y, image)
    table.insert(p, Sprite:new(x, y, image))
end

function Sprite:update(dt)
end

function Sprite:draw()
    love.graphics.draw(
        self.image, self.x * window.scale, self.y * window.scale, self.r,
        (self.flipped and -1 or (not self.flipped and 1)) * window.scale, window.scale
    )
end

--animatedsprite class
AnimatedSprite = inherits(Sprite, {
    frame = 1,
    framedelta = 0,
    framerate = 12
})
local animatedsprite_mt = class(AnimatedSprite)

--the skins param should be a sequence of strings referring to animation objects, or a single string
function AnimatedSprite:init(x, y, skins)
    local o = {
        x = x, y = y,
        skins = {}
    }
    
    if type(skins) == "string" then
        o.skins = { animations[skins] }
    elseif type(skins) == "table" then
        for i,_ in ipairs(skins) do
            o.skins[i] = animations[skins[i]]
        end
    else
        error("skins parameter is not a string or table of strings")
    end

    o.anim = o.skins[1]
    o.w = o.anim.image:getWidth() / o.anim.frames
    o.h = o.anim.image:getHeight()

    return o
end

function AnimatedSprite:new(x, y, skins)
    local o = AnimatedSprite:init(x, y, skins)

    return setmetatable(o, animatedsprite_mt)
end

function AnimatedSprite:add(x, y, skins)
    table.insert(p, AnimatedSprite:new(x, y, skins))
end

function AnimatedSprite:update(dt)
    self:animate(dt)
end

function AnimatedSprite:animate(dt)
    self.framedelta = self.framedelta + dt
    if self.framedelta > 1 / self.framerate then
        self.framedelta = self.framedelta - 1 / self.framerate
        self:advanceframe()
    end
end

function AnimatedSprite:advanceframe()
    self.frame = self.frame + 1
    if self.frame > self.anim.frames then
        self.frame = 1
    end
end

function AnimatedSprite:resetanimation()
    self.frame = 1
    self.framedelta = 0
end

function AnimatedSprite:swapanimation(anim)
    if self.anim ~= anim then
        self:resetanimation()
        self.anim = anim
    end
end

function AnimatedSprite:drawselfanim()
    love.graphics.draw(
        self.anim.image, self.anim.quads[self.frame],
        self.x * window.scale, self.y * window.scale, self.r,
        (self.flipped and -1 or (not self.flipped and 1)) * window.scale, window.scale
    )
end

function AnimatedSprite:draw()
    self:drawselfanim()

    if self.bounds ~= nil and showdebug then
        self.bounds:draw()
    end
end