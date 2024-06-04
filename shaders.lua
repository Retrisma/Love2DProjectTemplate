basic = {
    lights = {}
}

basic.shader = love.graphics.newShader[[
    uniform vec2[1] light_pos;
    uniform vec2 camera_pos;
    uniform float camera_scale;
    uniform vec2 player_pos;

    vec2 world_transform(vec2 world_coords) {
        return (world_coords - camera_pos) * camera_scale;
    }

    float light_source(vec2 screen_coords, vec2 light, float falloff) {
        float d = distance(screen_coords, world_transform(light));
        float intensity = 1.5 - (d / falloff);
        return clamp(intensity, 0.0, 1.0);
    }

    vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
        vec4 pixel = Texel(texture, texture_coords);
        
        float intensity = clamp(light_source(screen_coords, light_pos[0], 1000) + light_source(screen_coords, player_pos, 150), 0.0, 1.0);

        return pixel * intensity;
    }
]]

function basic.setup()
    basic.shader:send("light_pos", unpack(basic.lights))
end

function basic.update()
    basic.shader:send("player_pos", {player.x + player.width / 2, player.y + player.height / 2})
end