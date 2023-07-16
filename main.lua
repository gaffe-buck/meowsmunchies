TAIL_SPRITE = 68
TAIL_Y_OFFSET = 0
KIV_X = 64-16
KIV_Y = 128-32

function _init()
    return
end

function _draw()
    cls(15)
    draw_tail(72)
    draw_kiv(0)
end

function draw_tail(x, flip, dead)
    -- outline
    local outline_color = 0
    pal({
        [1] = outline_color,
        [2] = outline_color,
        [3] = outline_color,
        [4] = outline_color,
        [5] = outline_color,
        [6] = outline_color,
        [7] = outline_color,
        [8] = outline_color,
        [9] = outline_color,
        [10] = outline_color,
        [11] = outline_color,
        [12] = outline_color,
        [13] = outline_color,
        [14] = outline_color,
        [15] = outline_color,
    })
    spr(TAIL_SPRITE, x+1, KIV_Y+TAIL_Y_OFFSET, 4, 4)
    spr(TAIL_SPRITE, x-1, KIV_Y+TAIL_Y_OFFSET, 4, 4)
    spr(TAIL_SPRITE, x, KIV_Y+TAIL_Y_OFFSET+1, 4, 4)
    spr(TAIL_SPRITE, x, KIV_Y+TAIL_Y_OFFSET-1, 4, 4)
    -- base
    pal()
    spr(TAIL_SPRITE, x, KIV_Y+TAIL_Y_OFFSET, 4, 4)    
end

function draw_kiv(n)
    -- outline
    local outline_color = 0
    pal({
        [1] = outline_color,
        [2] = outline_color,
        [3] = outline_color,
        [4] = outline_color,
        [5] = outline_color,
        [6] = outline_color,
        [7] = outline_color,
        [8] = outline_color,
        [9] = outline_color,
        [10] = outline_color,
        [11] = outline_color,
        [12] = outline_color,
        [13] = outline_color,
        [14] = outline_color,
        [15] = outline_color,
    })    
    spr(n, KIV_X+1, KIV_Y, 4, 4)
    spr(n, KIV_X-1, KIV_Y, 4, 4)
    spr(n, KIV_X, KIV_Y+1, 4, 4)
    spr(n, KIV_X, KIV_Y-1, 4, 4)
    -- base
    pal()
    spr(n, KIV_X, KIV_Y, 4, 4)
end