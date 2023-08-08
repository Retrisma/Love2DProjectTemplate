require "assets"
require "input"
require "audio"
require "class"
require "collision"
require "map"
require "sprite"
require "ui"
require "actor"
require "player"
require "tools"
sti = require "lib/sti"
moonshine = require "lib/moonshine"

showdebug = false
debug = ""

window = { w = 1050, h = 600, scale = 1.65 }

camera = { x = 0, y = 0, rx = 0, ry = 0 }

speed = { target = 1 / 60, multiplier = 1 }

gamestate = { state = 0, main = 0, paused = 1 }

physics = { gravity = 100, friction = 20 }

p = {}

function love.load()
    love.window.setMode(window.w, window.h, {vsync = true})
	love.window.setTitle("Love2D Project Template")

    loadassets()
    
    font = love.graphics.setFont(fonts["CommonCase"])
    map = loadmap("slime")

    for k,v in pairs(p) do
        if v.user == "player" then player = v break end
    end

    Button:add(500, 300, "button", function() showdebug = not showdebug end)
    Textbox:add(500, 290, "debug button", { scroll = false })
end

function love.update(dt)
    --calculate fixed timestep
    local rate = speed.target * dt * speed.multiplier * 30
    local oldscale = window.scale

    updatemouse()

    if gamestate.state == gamestate.main then
        if showdebug then
            if love.keyboard.isDown("q") then window.scale = window.scale + rate * 5 end
            if love.keyboard.isDown("e") then window.scale = window.scale - rate * 5 end

            if love.keyboard.isDown("s") then camera.y = camera.y - rate * 1000 end
            if love.keyboard.isDown("d") then camera.x = camera.x - rate * 1000 end
            if love.keyboard.isDown("w") then camera.y = camera.y + rate * 1000 end
            if love.keyboard.isDown("a") then camera.x = camera.x + rate * 1000 end
        else
            camera.x = player.x * -1 + (window.w / 2 * (1 / window.scale))
            camera.y = player.y * -1 + (window.h / 2 * (1 / window.scale))
        end

        for _,v in pairs(p) do
            v:update(rate)
        end

        camera.ry = math.floor(camera.y)
        camera.rx = math.floor(camera.x)
    end

    mouse.op = mouse.p
    if oldscale ~= window.scale then
        map:resize(
            math.max(1, math.min(window.w * (1 / window.scale), 10000)), 
            math.max(1, math.min(window.h * (1 / window.scale), 10000))
        )
    end
end

function love.draw()
    --draw tiled map
    map:draw(camera.rx, camera.ry, window.scale, window.scale)

    love.graphics.push()
    --set drawing offset to camera position
    love.graphics.translate(camera.rx * window.scale, camera.ry * window.scale)
    
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