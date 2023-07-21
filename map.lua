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

function loadmap(map)
    local path = "Tiled/Maps/Exports/" .. map .. ".lua"
    local map = sti(path)

    local mapspr = Actor:new(0, 0, "animation")
    mapspr.body = {}
    mapspr.visible = false

    for x = 1, map.width do
        for y = 1, map.height do
            local tile = gettile("Template", x, y, map)
            if tile then
                if tile.gid ~= 0 then
                    if not (gettile("Template", x - 1, y, map) ~= nil 
                        and gettile("Template", x + 1, y, map) ~= nil
                        and gettile("Template", x, y - 1, map) ~= nil 
                        and gettile("Template", x, y + 1, map) ~= nil) then
                        mapspr:addbox(
                                tile.width, tile.height,
                                (x - 1) * tile.width, (y - 1) * tile.height
                            )
                    end
                end
            end
        end
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