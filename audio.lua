-- create a new audio instance with 2d position and optional direction
function audioInstance(path, x, y, theta)
    theta = theta or math.pi / 2

    local event = fmod.createInstance(path)
    fmod.set3DAttributes(event, x, y, 0, math.cos(theta), math.sin(theta), 0, 0, 0, 1)

    return event
end

-- update the listener 2d position and optional direction
function updateListener(x, y, theta)
    theta = theta or math.pi / -2
    fmod.setListener3DPosition(0, x, y, 0, math.cos(theta), math.sin(theta), 0, 0, 0, 1)
end

-- update an audio instance's 2d position and optional direction
function updateInstance(event, x, y, theta)
    theta = theta or math.pi / 2
    fmod.set3DAttributes(event, x, y, 0, math.cos(theta), math.sin(theta), 0, 0, 0, 1)
end

-- play a one-shot sound effect with 2d position and optional direction
function playSFX(path, x, y, theta)
    theta = theta or math.pi / 2
    return fmod.playOneShot3D(path, x, y, 0, math.cos(theta), math.sin(theta), 0, 0, 0, 1)
end