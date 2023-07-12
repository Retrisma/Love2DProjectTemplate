require "assets"
require "audio"
require "class"
require "map"
require "sprite"
require "actor"
require "tools"
sti = require("sti")

showdebug = true
debug = 0

window = { w = 800, h = 600 }
windowscale = 1

camera = { x = 0, y = 0 }
mouse = { x = 0, y = 0, p = false, op = false }

speed = { ideal = 1 / 60, multiplier = 1 }

p = {}

function love.load()
    love.window.setMode(window.w, window.h, {vsync = true})
    love.window.setTitle("Love2D Project Template")

    loadassets()
    
    map = loadmap("sample")
end

function love.update(dt)
    --calculate fixed timestep
    local rate = speed.ideal * dt * speed.multiplier * 30

    if love.keyboard.isDown("up") then windowscale = windowscale + rate end
    if love.keyboard.isDown("down") then windowscale = windowscale - rate end

    if love.keyboard.isDown("w") then camera.y = camera.y - rate * 100 end
    if love.keyboard.isDown("a") then camera.x = camera.x - rate * 100 end
    if love.keyboard.isDown("s") then camera.y = camera.y + rate * 100 end
    if love.keyboard.isDown("d") then camera.x = camera.x + rate * 100 end
    
    for _,v in pairs(p) do
        v:update(rate)
    end
end

function love.draw()
    love.graphics.push()
    love.graphics.translate(camera.x * windowscale, camera.y * windowscale)

    map:draw(camera.x, camera.y, windowscale)
    
    for _,v in pairs(p) do
        v:draw()
    end

    love.graphics.pop()
    if showdebug then
        love.graphics.print(tostring(debug))
    end
end