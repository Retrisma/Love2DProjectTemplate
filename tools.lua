showdebug = false
debug = {}

function printdebug()
    local out = ""
    for k,v in pairs(debug) do
        if type(v) == "table" or type(v) == "userdata" then
            out = out .. (k .. ": " .. type(v)) .. "\n"
        else
            out = out .. (k .. ": " .. v) .. "\n"
        end
    end

    return out
end

function math.mid(a, b, c)
    if a > b then
        if b > c then return b
        elseif a > c then return c
        else return a end
    else
        if a > c then return a
        elseif b > c then return c
        else return b end
    end
end

function qerp(current, target, dt, ease)
    if math.abs(current - target) < 0.01 then
        return target
    end
    
    return current + dt * (target - current) * (ease or 5)
end