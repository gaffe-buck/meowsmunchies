TAIL_SPRITE = 68
TAIL_Y_OFFSET = 4
TAIL_X = 64-16
TAIL_AMP = 24
TAIL_SPEED = 0.33
KIV_X = 64-16
KIV_Y = 128-32
BACKGROUND_COLOR = 15
KIV_IDLE = 0
KIV_OPEN = 4
KIV_FULL = 8
KIV_DEAD = 12
INITIAL_TOSS_INTERVAL = 1
CHEW_DURATION = 0.125

function _init()
    alive = true
    ready = false
    top_score = top_score or 0
    score = 0
    kiv_frame = KIV_IDLE
    mouth_open = false
    munchies = {}
    toss_interval = INITIAL_TOSS_INTERVAL
    time_for_next_toss = t()
    chew_until = 0
    explode_until = 0
end

function _update60()
    if btnp(❎) and not ready then
         ready = true
    end

    if alive then
        if ready then
            mouth_open = btn(❎)
        end
    else
        if btnp(🅾️) then _init() end
    end

    local dead_munchies = {}
    for munchie in all(munchies) do
        local munchie_is_alive = munchie:update()
        if not munchie_is_alive then
            add(dead_munchies, munchie)
        end
    end
    for dead_munchie in all(dead_munchies) do
        del(munchies, dead_munchie)
    end

    if alive and ready and t() > time_for_next_toss then
        add(munchies, make_munchie())
        time_for_next_toss = t() + toss_interval
    end

    -- determine kiv frame
    kiv_frame = mouth_open and KIV_OPEN or KIV_IDLE
    if t() < chew_until then kiv_frame = KIV_FULL end
    if not alive then kiv_frame = KIV_DEAD end
end

function _draw()
    cls(alive and BACKGROUND_COLOR or 5)
    draw_title()
    draw_tail(TAIL_X)
    draw_kiv(kiv_frame)

    draw_score()
    if alive and not ready then
        draw_get_ready()
    end
    if not alive then
        draw_game_over()
    end

    for munchie in all(munchies) do
        munchie:draw()
    end

    if t() <= explode_until then
        circfill(KIV_X + 16, KIV_Y + 8, rnd({32, 64, 72}), 8)
    end
end

function draw_game_over()
    local text_y = 64
    local text_x = 28 + 4
    fancy_text({
        text = "game over!",
        text_colors = { 1 },
        background_color = 7,
        x = text_x,
        y = text_y,
        bubble_depth = 1,
    })
    fancy_text({
        text = "your score: "..score,
        text_colors = { 1 },
        background_color = 7,
        x = text_x + 8,
        y = text_y + 11,
        bubble_depth = 1,
    })
    fancy_text({
        text = "press 🅾️  to try again",
        text_colors = { 1 },
        background_color = 7,
        x = text_x,
        y = text_y + 22,
        bubble_depth = 1,
    })
end

function draw_get_ready()
    fancy_text({
        text = "hold ❎  to open wide!",
        text_colors = { 1 },
        background_color = 7,
        x = 16 + 6,
        y = 64 + 16,
        bubble_depth = 1,
    })
end

function draw_score()
    color(1)
    print("score: "..score, 1, 1)
    print("top score: "..top_score, 128-48-8, 1)
    color()
end

function draw_title()
    local vertical_offset = 3
    local fancy_settings = {
        text_colors = { 1 },
        background_color = 13,
        bubble_depth = 2,
        outline_color = 6,
        wiggle = {
            amp = 1.25,
            speed = 1.5,
            offset = 0.33
        },
        letter_width = 8,
        big = true
    }

    fancy_settings.text = "meowskivich"
    fancy_settings.x = 20 
    fancy_settings.y = 9 + vertical_offset
    fancy_text(fancy_settings)

    fancy_settings.text = "muncher"
    fancy_settings.x = 38
    fancy_settings.y = 27 + vertical_offset
    fancy_text(fancy_settings)

    color(13)
    print("by gaffe for meowskivich", 16, 43 + vertical_offset)
    print("art fight 2023", 37, 49 + vertical_offset)
    color()
end

function draw_tail(x, dead)
    local flipx = false
    
    x = x + sin(t() * TAIL_SPEED) * TAIL_AMP
    if x < 64 - 16 then flipx = true end
    
    -- outline
    local outline_color = alive and 1 or 6
    pal_all(outline_color)
    spr(TAIL_SPRITE, x+1, KIV_Y+TAIL_Y_OFFSET, 4, 4, flipx)
    spr(TAIL_SPRITE, x-1, KIV_Y+TAIL_Y_OFFSET, 4, 4, flipx)
    spr(TAIL_SPRITE, x, KIV_Y+TAIL_Y_OFFSET+1, 4, 4, flipx)
    spr(TAIL_SPRITE, x, KIV_Y+TAIL_Y_OFFSET-1, 4, 4, flipx)
    -- base
    if alive then pal() else pal_all(0) end
    spr(TAIL_SPRITE, x, KIV_Y+TAIL_Y_OFFSET, 4, 4, flipx)    
    pal()
end

function draw_kiv(n)
    -- outline
    local outline_color = alive and 1 or 6
    pal_all(outline_color)
    spr(n, KIV_X+1, KIV_Y, 4, 4)
    spr(n, KIV_X-1, KIV_Y, 4, 4)
    spr(n, KIV_X, KIV_Y+1, 4, 4)
    spr(n, KIV_X, KIV_Y-1, 4, 4)
    -- base
    if alive then pal() else pal({ [13] = 0 }) end
    spr(n, KIV_X, KIV_Y, 4, 4)
    pal()
end

-- util
function pal_all(outline_color)
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
end