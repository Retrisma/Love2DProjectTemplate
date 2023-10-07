--rectangle class
Rectangle = { }
local rectangle_mt = class(Rectangle)

function Rectangle:init(x, y, width, height, xoff, yoff)
    --offset values are meant for rectangles that are offset to the coordinates of physics bodies
    xoff = xoff or 0
    yoff = yoff or 0
    local o = {
        x = x, y = y, width = width, height = height, xoff = xoff, yoff = yoff
    }

    return o
end

function Rectangle:new(x, y, width, height, xoff, yoff)
    local o = Rectangle:init(x, y, width, height, xoff, yoff)
    return setmetatable(o, rectangle_mt)
end

--checks to see if this rectangle intersects with a given point
function Rectangle:containspoint(x, y)
    return x >= self.x and x <= self.x + self.width and y >= self.y and y <= self.y + self.height
end

--checks to see if this rectangle intersects with another rectangle, with an optional offset applied to this
function Rectangle:collideswith(rect, offset)
    offset = offset or { x = 0, y = 0 }
    return math.abs((self.x + offset.x + (self.width / 2)) - (rect.x + (rect.width / 2))) < self.width / 2 + rect.width / 2
        and math.abs((self.y + offset.y + (self.height / 2)) - (rect.y + (rect.height / 2))) < self.height / 2 + rect.height / 2
end

function Rectangle:draw(color, mode)
    if mode == nil then
        mode = "line"
        if self:containspoint(mouse.x, mouse.y) then mode = "fill" end
    end

    color = color or { r = 1, g = 1, b = 1 }
    love.graphics.setColor(color.r, color.g, color.b)
    love.graphics.rectangle(
        mode,
        self.x, self.y,
        self.width, self.height
    )
    love.graphics.setColor(1, 1, 1)
end