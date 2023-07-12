spawntable = {
    friend = function(x, y) Sprite:add(x, y, "friend") end,
    animation = function(x, y) Actor:add(x, y, "animation") end
}

function loadmap(map)
    local path = "Tiled/Maps/Exports/" .. map .. ".lua"
    local map = sti(path)

    spawn(map)

    return map
end

function spawn(map)
    for k,v in pairs(map.objects) do
        spawntable[v.name](v.x, v.y)
    end
end