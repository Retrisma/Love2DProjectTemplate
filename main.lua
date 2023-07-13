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
sti = require("sti")

showdebug = true
debug = 0

window = { w = 800, h = 600, scale = 1 }

camera = { x = 0, y = 0 }

speed = { ideal = 1 / 60, multiplier = 1 }

p = {}

function love.load()
    love.window.setMode(window.w, window.h, {vsync = true})
    love.window.setTitle("Love2D Project Template")

    loadassets()
    
    map = loadmap("sample")

    Button:add(180, 40, "button", function() showdebug = not showdebug end)
end

function love.update(dt)
    --calculate fixed timestep
    local rate = speed.ideal * dt * speed.multiplier * 30

    updatemouse()

    if love.keyboard.isDown("up") then window.scale = window.scale + rate end
    if love.keyboard.isDown("down") then window.scale = window.scale - rate end

    if love.keyboard.isDown("w") then camera.y = camera.y - rate * 100 end
    if love.keyboard.isDown("a") then camera.x = camera.x - rate * 100 end
    if love.keyboard.isDown("s") then camera.y = camera.y + rate * 100 end
    if love.keyboard.isDown("d") then camera.x = camera.x + rate * 100 end
    
    for _,v in pairs(p) do
        v:update(rate)
    end

    debug = tostring(mouse.p) .. " " .. tostring(mouse.held)

    mouse.op = mouse.p
end

function love.draw()
    love.graphics.push()
    love.graphics.translate(camera.x * window.scale, camera.y * window.scale)
    
    love.graphics.circle("fill", mouse.x, mouse.y, 3)

    map:draw(camera.x, camera.y, window.scale)
    
    for _,v in pairs(p) do
        v:draw()
    end

    love.graphics.pop()
    if showdebug then
        love.graphics.print(tostring(debug))
    end
end