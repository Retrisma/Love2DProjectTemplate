camera = { x = 0, y = 0, rx = 0, ry = 0, init = false }

function caminit(map)
    camera.xmin = 0
    camera.xmax = map.width * map.tilewidth - window.w * (1 / window.scale)
    camera.ymin = 0
    camera.ymax = map.height * map.tileheight - window.h * (1 / window.scale)
    camera.init = true
end

function camfollowsprite(o)
    camera.x = o.x - ((window.w / 2) * (1 / window.scale))
    camera.y = o.y - ((window.h / 2) * (1 / window.scale))
end

function camupdate()
    if camera.init then
        camera.x = math.min(math.max(camera.x, camera.xmin), camera.xmax)
        camera.y = math.min(math.max(camera.y, camera.ymin), camera.ymax)
    end

    camera.rx = math.floor(camera.x)
    camera.ry = math.floor(camera.y)
end