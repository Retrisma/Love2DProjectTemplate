--anonymous functions connected with spawn objects in the map
spawntable = {
    friend = function(v)
        local data = getobjectdata(v)
        Sprite:add(data.x, data.y, "friend")
    end,
    animation = function(v)
        local data = getobjectdata(v)
        local a = Player:new(
            data.x, data.y, "animation",
            { default = true, type = "dynamic" }
        )
        a.user = "player"
        table.insert(p, a)
    end,


    CamLockY = function(v)
        local data = getobjectdata(v)
        CameraLockTrigger:add(data.x, data.y, data.width, data.height, false, data.y)
    end,
    CamUnlockY = function(v)
        local data = getobjectdata(v)
        CameraLockTrigger:add(data.x, data.y, data.width, data.height, false, false)
    end
}

--get tile data from a layer at given coordinates
function gettile(layer, x, y, custommap)
    custommap = custommap or map
    local l = custommap.layers[layer]

    if y <= 0 or x <= 0 or y > custommap.height or x > custommap.width then return nil end

    return l.data[y][x]
end

--check to see if a tile is surrounded by other tiles on this layer
function surrounded(layer, x, y, custommap)
    custommap = custommap or map
    return gettile(layer, x - 1, y, custommap) ~= nil 
        and gettile(layer, x + 1, y, custommap) ~= nil
        and gettile(layer, x, y - 1, custommap) ~= nil 
        and gettile(layer, x, y + 1, custommap) ~= nil
end

--populate collision layers with fixtures applied to the map's physics object
function addcollisionlayer(map, layer, mapspr)
    local x = 1
    for y = 1, map.height do
        while x <= map.width do
            local tile = gettile(layer, x, y, map)
            if tile and tile.gid ~= 0 and not surrounded(layer, x, y, map) then
                local ox = x
                local width = tile.width

                --extend box horizontally
                while gettile(layer, x + 1, y, map) ~= nil do
                    width = width + tile.width
                    x = x + 1
                end

                --extend box vertically
                for _,box in pairs(mapspr.body) do
                    if box.width == width and box.x == (ox - 1) * tile.width
                    and (y - 1) * tile.height >= box.y and (y - 1) * tile.height <= box.y + box.height then
                        box.height = box.height + tile.height
                        goto mapcont
                    end
                end

                mapspr:addbox(
                    width, tile.height,
                    (ox - 1) * tile.width, (y - 1) * tile.height
                )
                ::mapcont::
            end
            x = x + 1
        end
        x = 1
    end
end

--load a map file, including spawning entities and generating collision
function loadmap(map)
    local path = "Tiled/Maps/Exports/" .. map .. ".lua"
    local map = sti(path)

    local mapspr = Actor:new(0, 0, "animation", { type = "static" })
    mapspr.body = {}
    mapspr.visible = false

    for k,layer in pairs(map.layers) do
        if type(k) == "number" then goto layercont end
        if layer.objects ~= nil then
            layer.opacity = 0
            goto layercont
        end
        if layer.properties["collidable"] ~= true then goto layercont end

        addcollisionlayer(map, layer.name, mapspr)

        ::layercont::
    end

    table.insert(p, mapspr)

    spawn(map)
    caminit(map)

    return map
end

--look up in the spawntable for each object in the map
function spawn(map)
    for k,v in pairs(map.objects) do
        if spawntable[v.name] then
            spawntable[v.name](v)
        end
    end
end

function getobjectdata(v)
    return {
        x = math.floor(v.x), y = math.floor(v.y),
        width = math.floor(v.width),
        height = math.floor(v.height)
    }
end