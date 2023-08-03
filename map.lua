spawntable = {
    friend = function(x, y) 
        Sprite:add(x, y, "friend") 
    end,
    animation = function(x, y) 
        Actor:add(
            x, y, "animation", 
            { default = true, type = "dynamic" }
        )
    end
}

function gettile(layer, x, y, custommap)
    custommap = custommap or map
    local l = custommap.layers[layer]

    if y <= 0 or x <= 0 or y > custommap.height or x > custommap.width then return nil end

    return l.data[y][x]
end

function surrounded(layer, x, y, custommap)
    custommap = custommap or map
    return gettile(layer, x - 1, y, custommap) ~= nil 
        and gettile(layer, x + 1, y, custommap) ~= nil
        and gettile(layer, x, y - 1, custommap) ~= nil 
        and gettile(layer, x, y + 1, custommap) ~= nil
end

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
                    if box.w == width and box.x == (ox - 1) * tile.width
                    and (y - 1) * tile.height >= box.y and (y - 1) * tile.height <= box.y + box.h then
                        box.h = box.h + tile.height
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

function loadmap(map)
    local path = "Tiled/Maps/Exports/" .. map .. ".lua"
    local map = sti(path)

    local mapspr = Actor:new(0, 0, "animation")
    mapspr.body = {}
    mapspr.visible = false

    for k,layer in pairs(map.layers) do
        if type(k) == "number" then goto layercont end
        if layer.objects ~= nil then goto layercont end
        if layer.properties["collidable"] ~= true then goto layercont end

        addcollisionlayer(map, layer.name, mapspr)

        ::layercont::
    end

    table.insert(p, mapspr)
    debug = #mapspr.body

    spawn(map)

    return map
end

function spawn(map)
    for k,v in pairs(map.objects) do
        if spawntable[v.name] then
            spawntable[v.name](math.floor(v.x), math.floor(v.y))
        end
    end
end