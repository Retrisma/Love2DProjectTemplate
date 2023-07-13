mouse = { x = 0, y = 0, p = false, op = false, held = false }

function updatemouse()
    mouse.x, mouse.y = love.mouse.getPosition()
    mouse.x = mouse.x - camera.x * window.scale
    mouse.y = mouse.y - camera.y * window.scale

    mouse.p = false
    
    if love.mouse.isDown(1) then
        if (not mouse.op) and (not mouse.held) then
            mouse.p = true
        end
        if mouse.op then
            mouse.held = true
        end
    else
        mouse.held = false
    end
end