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
require "drawing"
sti = require "lib/sti"
moonshine = require "lib/moonshine"

window = { width = 1050, height = 600, scale = 1.3 }

speed = { target = 1 / 60, multiplier = 1 }

gamestate = { state = 0, main = 0, paused = 1 }

physics = { gravity = 100, friction = 20 }

p = {}

function love.load()
    love.window.setMode(window.width, window.height, { vsync = false })
	love.window.setTitle("Love2D Project Template")
    love.graphics.setDefaultFilter("nearest", "nearest")

    loadassets()
    
    font = love.graphics.setFont(fonts["ElixiR"])
    map = loadmap("slime")

    for _,v in pairs(p) do
        if v.user == "player" then player = v break end
    end

    Button:add(300, 2900, "button", function() showdebug = not showdebug end)
    Textbox:add(500, 290, "debug button", { scroll = false })
end

function love.update(dt)
    --calculate fixed timestep
    local rate = speed.target * dt * speed.multiplier * 30

    updatecamera(dt)
    updatemouse()

    debug.mx = mouse.x
    debug.my = mouse.y
    debug.px = player.x
    debug.py = player.y
    debug.cx = camera.fx
    debug.cy = camera.fy

    --update all sprites
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
    love.graphics.scale(window.scale)
    love.graphics.translate(camera.fx * -1, camera.fy * -1)
    
    --sort the sprite table by drawing depth
    table.sort(p, function(a, b) return (a.depth or 5) < (b.depth or 5) end)
    --draw all sprites
    for _,v in pairs(p) do
        drawobject(v)
    end

    --draw mouse cursor
    love.graphics.circle("fill", mouse.x, mouse.y, 3)

    love.graphics.pop()

    --if showdebug then
        love.graphics.print(printdebug(), 0, 0)
    --end
end