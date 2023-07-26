Rectangle = {
    xoff = 0, yoff = 0
}
local rectangle_mt = class(Rectangle)

function Rectangle:new(x, y, w, h)
    local o = {
        x = x, y = y, w = w, h = h
    }
    return setmetatable(o, rectangle_mt)
end

function Rectangle:translate()
    return Rectangle:new(
        self.x * window.scale, self.y * window.scale,
        self.w * window.scale, self.h * window.scale
    )
end

function Rectangle:containspoint(x, y)
    local sr = self:translate()
    return x >= sr.x and x <= sr.x + sr.w and y >= sr.y and y <= sr.y + sr.h
end

function Rectangle:collideswith(rect, offset)
    offset = offset or { x = 0, y = 0 }
    return math.abs((self.x+offset.x+(self.w/2))-(rect.x+(rect.w/2)))<self.w/2+rect.w/2 
        and math.abs((self.y+offset.y+(self.h/2))-(rect.y+(rect.h/2)))<self.h/2+rect.h/2
end

function Rectangle:draw(color)
    local mode = "line"
    if self:containspoint(mouse.x, mouse.y) then mode = "fill" end

    color = color or { r = 1, g = 1, b = 1 }
    love.graphics.setColor(color.r, color.g, color.b)
    local sr = self:translate()
    love.graphics.rectangle(
        mode, sr.x, sr.y, 
        sr.w, sr.h
    )
    love.graphics.setColor(1, 1, 1)
end