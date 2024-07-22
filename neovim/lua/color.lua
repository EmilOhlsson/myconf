local M = {
    BLUE = 240 / 360,
    GREEN = 120 / 360,
    PINK = 320 / 360,
    PURPLE = 280 / 360,
    RED = 0 / 360,
    TURQOISE = 180 / 360,
    YELLOW = 60 / 360,
}

M.hsv2rgb = function(h, s, v)
    local i = math.floor(h * 6)
    local f = h * 6 - i

    function v_mul(x)
        return v * (1 - x * s)
    end

    local p, q, t = v_mul(1), v_mul(f), v_mul(1 - f)

    i = i % 6
    if i == 0 then
        return v, t, p
    elseif i == 1 then
        return q, v, p
    elseif i == 2 then
        return p, v, t
    elseif i == 3 then
        return p, q, v
    elseif i == 4 then
        return t, p, v
    elseif i == 5 then
        return v, p, q
    end
end

M.rgb2hex = function(r, g, b)
    return string.format("#%02x%02x%02x", math.floor(255 * r), math.floor(255 * g), math.floor(255 * b))
end

M.hsv2hex = function(h, s, v)
    return M.rgb2hex(M.hsv2rgb(h, s, v))
end

return M

-- vim: set et ts=4 sw=4 ss=4 tw=100 :
