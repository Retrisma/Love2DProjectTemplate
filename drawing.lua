function drawobject(o)
    local drawmode = o.drawmode or "relative"
    local visible = o.visible or true
    if visible then
        if drawmode == "absolute" then
            love.graphics.push()
            love.graphics.origin()
        end

        o:draw()

        if drawmode == "absolute" then
            love.graphics.pop()
        end
    end
end