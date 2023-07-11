--instantiate a class's metatable
function class(members)
    members = members or {}
    local mt = {
        __metatable = members;
        __index = members;
    }

    local function new(_, init)
        return setmetatable(init or {}, mt)
    end

    local function copy(obj, ...)
        local newobj = obj:new(unpack(arg))
        for n,v in pairs(obj) do newobj[n] = v end
        return newobj
    end

    members.new  = members.new or new
    members.copy = members.copy or copy

    return mt
end

--simple inheritance method
function inherits(baseclass, members)
    local newclass = members or {}

    if baseclass then
        setmetatable( newclass, { __index = baseclass } )
    end

    return newclass
end