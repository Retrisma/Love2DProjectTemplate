mouse = { x = 0, y = 0, p = false, op = false, held = false }

function updatemouse()
    mouse.x, mouse.y = love.mouse.getPosition()
    --mouse.x = mouse.x - camera.fx * window.scale * -1
    --mouse.y = mouse.y - camera.fy * window.scale * -1

    mouse.x = (mouse.x / window.scale) + camera.fx
    mouse.y = (mouse.y / window.scale) + camera.fy

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

function love.keypressed(key, scancode, isrepeat)
    if key == "backspace" then showdebug = not showdebug end
end