require "assets"
require "input"
require "audio"
require "class"
require "collision"
require "map"
require "sprite"
require "ui"
require "actor"
require "tools"
sti = require "sti"
moonshine = require "moonshine"

showdebug = true
debug = ""

window = { w = 1050, h = 600, scale = 1.65 }

camera = { x = 0, y = 0, rx = 0, ry = 0 }

speed = { target = 1 / 60, multiplier = 1 }

gamestate = { state = 0, main = 0, paused = 1 }

p = {}

function love.load()
    love.window.setMode(window.w, window.h, {vsync = true})
    love.window.setTitle("Love2D Project Template")

    loadassets()
    
    font = love.graphics.setFont(fonts["CommonCase"])
    map = loadmap("sample")

    Button:add(500, 40, "button", function() showdebug = not showdebug end)
    Textbox:add(850, 20, "debug button", { scroll = false })
    Textbox:add(50, 550, "i am a scrolling text box of text.", { scroll = true })
end

function love.update(dt)
    --calculate fixed timestep
    local rate = speed.target * dt * speed.multiplier * 30

    updatemouse()

    if gamestate.state == gamestate.main then
        if love.keyboard.isDown("q") then window.scale = window.scale + rate * 5 end
        if love.keyboard.isDown("e") then window.scale = window.scale - rate * 5 end

        if love.keyboard.isDown("s") then camera.y = camera.y - rate * 100 end
        if love.keyboard.isDown("d") then camera.x = camera.x - rate * 100 end
        if love.keyboard.isDown("w") then camera.y = camera.y + rate * 100 end
        if love.keyboard.isDown("a") then camera.x = camera.x + rate * 100 end

        for _,v in pairs(p) do
            v:update(rate)
        end

        camera.rx = math.floor(camera.x)
        camera.ry = math.floor(camera.y)
    end

    mouse.op = mouse.p
end

function love.draw()
    map:draw(camera.rx, camera.ry, window.scale)

    love.graphics.push()
    --set drawing offset to camera position
    love.graphics.translate(camera.rx * window.scale, camera.ry * window.scale)
    --draw tiled map
    
    for _,v in pairs(p) do
        v:draw()
    end

    --draw mouse cursor
    love.graphics.circle("fill", mouse.x, mouse.y, 3)

    love.graphics.pop()
    if showdebug then
        love.graphics.print(tostring(debug or 0))
    end
end