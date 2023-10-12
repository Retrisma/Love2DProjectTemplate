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

window = { width = 800, height = 460, scale = 1.3 }

speed = { target = 1 / 60, multiplier = 1 }

gamestate = { state = 0, main = 0, paused = 1 }

physics = { gravity = 100, friction = 20 }

p = {}

function love.load()
    window.width = window.width * window.scale
    window.height = window.height * window.scale

    love.window.setMode(window.width, window.height, { vsync = false })
	love.window.setTitle("Love2D Project Template")
    love.graphics.setDefaultFilter("nearest", "nearest")

    loadassets()
    
    font = love.graphics.setFont(fonts["ElixiR"])
    map = loadmap("slime")

    for _,v in pairs(p) do
        if v.user == "player" then player = v break end
    end

    Button:add(50, 100, "button", function() showdebug = not showdebug end)
    Textbox:add(200, 100, "Everyone knows Mario is cool as fuck. Everyone knows Mario is cool as fuck.", {
        scroll = true,
        shadow = { 1, 0, 0 },
        image = images["dialoguebox"],
        hpad = 15,
        vpad = 10,
        font = fonts["ElixiR"]
    })
end

function love.update(dt)
    --calculate fixed timestep
    local rate = speed.target * dt * speed.multiplier * 30

    updatecamera(rate)
    updatemouse()

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