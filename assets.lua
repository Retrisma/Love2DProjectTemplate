--load all assets from a folder, with a flag corresponding to the type of asset it is.
--audio is no longer handled here, so it is currently only used for graphics.
function loadfolder(path, type)
    names = love.filesystem.getDirectoryItems(path)

    out = {}

    --for each file in the folder, load it into a table with its filename as a key.
    for i = 1, #names do
        local lpath = path .. "/" .. names[i]
        local shortname = string.sub(names[i], 1, #names[i] - 4)

        if type == "image" then
            out[shortname] = love.graphics.newImage(lpath)
        elseif type == "anim" then
            --for animations, there should be a number following the name of the animation with frame count.
            --for example: animation6.png (has 6 frames)
            local f = tonumber(string.match(shortname, '%f[%d]%d[,.%d]*%f[%D]'))
            shortname = string.gsub(shortname, "%d+", "")

            --animation object includes the source image, and every quad that is on that image for drawing.
            out[shortname] = {
                image = love.graphics.newImage(lpath),
                frames = f,
                quads = {}
            }

            out[shortname].width = out[shortname].image:getWidth() / f
            out[shortname].height = out[shortname].image:getHeight()

            --populate the quads with each frame of animation.
            for x = 0, out[shortname].frames - 1 do
                out[shortname].quads[x + 1] = love.graphics.newQuad(x * out[shortname].image:getWidth() / out[shortname].frames, 0,
                    out[shortname].image:getWidth() / out[shortname].frames, out[shortname].image:getHeight(),
                    out[shortname].image:getWidth(), out[shortname].image:getHeight())
            end
        elseif type == "font" then
            out[shortname] = love.graphics.newFont(lpath, 20)
        end
    end

    return out
end

function loadassets()
    images = loadfolder("Graphics/Sprites", "image")
    animations = loadfolder("Graphics/Animations", "anim")
    fonts = loadfolder("Graphics/Fonts", "font")
end