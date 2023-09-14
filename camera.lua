camera = { 
    x = 0, y = 0,
    rx = 0, ry = 0,
    xoff = 0, yoff = 0,
    init = false,
    damping = 10
}

function caminit(map)
    camera.xmin = 0
    camera.xmax = map.width * map.tilewidth - window.w * (1 / window.scale)
    camera.ymin = 0
    camera.ymax = map.height * map.tileheight - window.h * (1 / window.scale)
    camera.init = true
    camera.scale = window.scale

    map:resize(
        math.mid(1, window.w * (1 / window.scale), 10000),
        math.mid(1, window.h * (1 / window.scale), 10000)
    )
end

function camfollowsprite(o, dt)
    local deadzone = 0.1 -- the middle horizontal n% of the screen is a camera deadzone
    local ox = o:translate().x / (window.w * (1 / window.scale))

    local px, py = camera.x, camera.y
    
    if ox > 0.5 + deadzone / 2 then
        px = o.x - ((0.5 + deadzone / 2) * (window.w * (1 / window.scale)))
    elseif ox < 0.5 - deadzone / 2 then
        px = o.x - ((0.5 - deadzone / 2) * (window.w * (1 / window.scale)))
    end

    debug = px

    if o:collides({x = 0, y = 1}) then py = o.y - ((window.h * 0.7) * (1 / window.scale)) end

    camera.x = qerp(camera.x, px, dt)
    camera.y = qerp(camera.y, py, dt)
end

function updatecamera()
    if camera.init then
        camera.x = math.mid(camera.x, camera.xmin, camera.xmax)
        camera.y = math.mid(camera.y, camera.ymin, camera.ymax)
    end

    if camera.scale ~= window.scale then
        caminit(map)
    end

    camera.rx = math.floor(camera.x)
    camera.ry = math.floor(camera.y)
end