camera = {
    x = 0, y = 0, -- target coordinates
    rx = 0, ry = 0, -- real coordinates
    fx = 0, fy = 0, -- rounded coordinates
    xoff = 0, yoff = 0, -- offset
    xlock = false, ylock = false, -- camera lock coordinates
    init = false,
    damping = 2
}

function caminit(map)
    camera.xmin = 0
    camera.xmax = map.width * map.tilewidth - window.width * (1 / window.scale)
    camera.ymin = 0
    camera.ymax = map.height * map.tileheight - window.height * (1 / window.scale)
    camera.init = true
    camera.scale = window.scale

    map:resize(
        math.mid(1, window.width * (1 / window.scale), 10000),
        math.mid(1, window.height * (1 / window.scale), 10000)
    )
end

function camfollowsprite(o)
    local deadzone = 0.0 -- the middle horizontal n of the screen is a camera deadzone
    local ox = o:translate().x / (window.width * (1 / window.scale))

    --lookahead
    if o.flipped then camera.xoff = -0.1
    else camera.xoff = 0.1 end
    
    --update camera x when o leaves the deadzone
    if ox > 0.5 + deadzone / 2 then
        camera.x = o.x - ((0.5 + (deadzone / 2)) * (window.width * (1 / window.scale)))
    elseif ox < 0.5 - deadzone / 2 then
        camera.x = o.x - ((0.5 - (deadzone / 2)) * (window.width * (1 / window.scale)))
    end

    --only update camera y when o is grounded
    if o:collides({x = 0, y = 1}) then camera.y = o.y - ((window.height * 0.6) * (1 / window.scale)) end
end

function updatecamera(dt)
    --snap camera to the camera bounds
    if camera.init then
        camera.x = math.mid(camera.x, camera.xmin, camera.xmax)
        camera.y = math.mid(camera.y, camera.ymin, camera.ymax)
    end

    if camera.scale ~= window.scale then
        caminit(map)
    end

    --if camera is locked, snap it to the lock coordinate
    if camera.xlock then camera.x = camera.xlock end
    if camera.ylock then camera.y = camera.ylock end

    --if the camera target is different from the current position, interpolate to it
    camera.rx = qerp(camera.rx, camera.x + (camera.xoff * (window.width * (1 / window.scale))), dt * camera.damping)
    camera.ry = qerp(camera.ry, camera.y, dt * camera.damping)

    camera.fx = math.floor(camera.rx)
    camera.fy = math.floor(camera.ry)
end