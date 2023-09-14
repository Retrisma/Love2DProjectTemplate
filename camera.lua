camera = {
    x = 0, y = 0, -- target coordinates
    rx = 0, ry = 0, -- real coordinates
    fx = 0, fy = 0, -- rounded coordinates
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

function camfollowsprite(o)
    local deadzone = 0.1 -- the middle horizontal n of the screen is a camera deadzone
    local ox = o:translate().x / (window.w * (1 / window.scale))

    if o.flipped then camera.xoff = -0.1
    else camera.xoff = 0.1 end
    
    if ox > 0.5 + deadzone / 2 then
        camera.x = o.x - ((0.5 + (deadzone / 2)) * (window.w * (1 / window.scale)))
    elseif ox < 0.5 - deadzone / 2 then
        camera.x = o.x - ((0.5 - (deadzone / 2)) * (window.w * (1 / window.scale)))
    end

    if o:collides({x = 0, y = 1}) then camera.y = o.y - ((window.h * 0.7) * (1 / window.scale)) end
end

function updatecamera(dt)
    if camera.init then
        camera.x = math.mid(camera.x, camera.xmin, camera.xmax)
        camera.y = math.mid(camera.y, camera.ymin, camera.ymax)
    end

    if camera.scale ~= window.scale then
        caminit(map)
    end

    camera.rx = qerp(camera.rx, camera.x + (camera.xoff * (window.w * (1 / window.scale))), dt)
    camera.ry = qerp(camera.ry, camera.y, dt)

    camera.fx = math.floor(camera.rx)
    camera.fy = math.floor(camera.ry)
end