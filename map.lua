spawntable = {
    friend = function(x, y) Sprite:add(x, y, "friend") end,
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
    return gettile("Template", x - 1, y, custommap) ~= nil 
        and gettile("Template", x + 1, y, custommap) ~= nil
        and gettile("Template", x, y - 1, custommap) ~= nil 
        and gettile("Template", x, y + 1, custommap) ~= nil
end

function loadmap(map)
    debug = 0

    local path = "Tiled/Maps/Exports/" .. map .. ".lua"
    local map = sti(path)

    local mapspr = Actor:new(0, 0, "animation")
    mapspr.body = {}
    mapspr.visible = false

    local x = 1
    for y = 1, map.height do
        while x <= map.width do
            local tile = gettile("Template", x, y, map)
            if tile then
                if tile.gid ~= 0 then
                    if not surrounded("Template", x, y, map) then
                        local ox = x
                        local width = tile.width
                        while gettile("Template", x + 1, y, map) ~= nil do
                            width = width + tile.width
                            x = x + 1
                        end

                        for _,box in pairs(mapspr.body) do
                            if box.w == width and box.x == (ox - 1) * tile.width
                            and (y - 2) * tile.height >= box.y and (y - 2) * tile.height <= box.y + box.h then
                                box.h = box.h + tile.height
                                goto mapcont
                            end
                        end

                        mapspr:addbox(
                            width, tile.height,
                            (ox - 1) * tile.width, (y - 1) * tile.height
                        )
                        debug = #mapspr.body
                        ::mapcont::
                    end
                end
            end
            x = x + 1
        end
        x = 1
    end

    for _,box in pairs(mapspr.body) do
        print(box.x .. "," .. box.y .. "|" .. box.w .. "\n")
    end

    table.insert(p, mapspr)

    spawn(map)

    return map
end

function spawn(map)
    for k,v in pairs(map.objects) do
        spawntable[v.name](math.floor(v.x), math.floor(v.y))
    end
end