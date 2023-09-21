require "assets"
require "input"
require "audio"
require "class"
require "camera"
require "collision"
require "map"
require "sprite"
require "ui"
require "actor"
require "player"
require "triggers"
require "tools"
sti = require "lib/sti"
moonshine = require "lib/moonshine"

window = { w = 1050, h = 600, scale = 1.3 }

speed = { target = 1 / 60, multiplier = 1 }

gamestate = { state = 0, main = 0, paused = 1 }

physics = { gravity = 100, friction = 20 }

p = {}

function love.load()
    love.window.setMode(window.w, window.h, { vsync = false })
	love.window.setTitle("Love2D Project Template")

    loadassets()
    
    font = love.graphics.setFont(fonts["CommonCase"])
    map = loadmap("slime")

    for _,v in pairs(p) do
        if v.user == "player" then player = v break end
    end

    Button:add(500, 300, "button", function() showdebug = not showdebug end)
    Textbox:add(500, 290, "debug button", { scroll = false })
end

function love.update(dt)
    --calculate fixed timestep
    local rate = speed.target * dt * speed.multiplier * 30

    updatecamera(dt)

    updatemouse()

    for _,v in pairs(p) do
        v:update(rate)
    end

    if gamestate.state == gamestate.main then
        if showdebug then
            if love.keyboard.isDown("q") then window.scale = window.scale + rate * 5 end
            if love.keyboard.isDown("e") then window.scale = window.scale - rate * 5 end

            if love.keyboard.isDown("d") then camera.x = camera.x + rate * 500 end
            if love.keyboard.isDown("a") then camera.x = camera.x - rate * 500 end
            if love.keyboard.isDown("w") then camera.y = camera.y - rate * 500 end
            if love.keyboard.isDown("s") then camera.y = camera.y + rate * 500 end
            
            --camfollowsprite(player)
        else
            camfollowsprite(player)
        end
    end

    mouse.op = mouse.p
end

function love.draw()
    --draw tiled map
    map:draw(camera.fx * -1, camera.fy * -1, window.scale, window.scale)

    love.graphics.push()
    --set drawing offset to camera position
    love.graphics.translate(camera.fx * window.scale * -1, camera.fy * window.scale * -1)
    
    for _,v in pairs(p) do
        v:draw()
    end

    --draw mouse cursor
    love.graphics.circle("fill", mouse.x, mouse.y, 3)
    love.graphics.pop()

    --if showdebug then
        love.graphics.print(printdebug(), 0, 0)
    --end
end