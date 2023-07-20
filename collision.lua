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

function Rectangle:collideswith(rect)
    return self.x < rect.x + rect.w and self.x + self.w > rect.x and
        self.y > rect.y + rect.h and self.y + self.h < rect.y
end

function Rectangle:draw()
    love.graphics.setColor(0, 0, 1)
        local sr = self:translate()
        love.graphics.rectangle(
            "line", sr.x, sr.y, 
            sr.w, sr.h
        )
    love.graphics.setColor(1, 1, 1)
end