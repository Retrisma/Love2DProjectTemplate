require "assets"
require "audio"
require "class"
require "sprite"
require "tools"
sti = require("sti")

showdebug = true
debug = 0

window = { w = 800, h = 600 }
windowscale = 1

camera = { x = 0, y = 0 }
mouse = { x = 0, y = 0, p = false, op = false }

p = {}

function love.load()
    love.window.setMode(window.w, window.h, {vsync = false})
    love.window.setTitle("Love2D Project Template")
    map = sti("Tiled/Maps/Exports/sample.lua")

    loadassets()

    Sprite:add(50, 50, "friend")
    AnimatedSprite:add(100, 100, "animation")
end

function love.update(dt)
    if love.keyboard.isDown("up") then windowscale = windowscale + dt end
    if love.keyboard.isDown("down") then windowscale = windowscale - dt end

    if love.keyboard.isDown("w") then camera.y = camera.y - dt * 100 end
    if love.keyboard.isDown("a") then camera.x = camera.x - dt * 100 end
    if love.keyboard.isDown("s") then camera.y = camera.y + dt * 100 end
    if love.keyboard.isDown("d") then camera.x = camera.x + dt * 100 end

    for _,v in pairs(p) do
        v:update(dt)
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