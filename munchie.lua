END_X = 64
END_Y = 128 - 16
M_CHICKEN = 64
M_BOMB = 66
M_CHERRY = 96
M_CAKE = 98
M_FOOD = { M_CAKE, M_CHERRY, M_CHICKEN, M_BOMB }
MIN_TOSS_INTERVAL = 0.2

function _munchie_update(munchie)
    local absolute_progress = 1 + ((munchie.end_time - t()) / (munchie.start_time - munchie.end_time))
    absolute_progress = absolute_progress > 1 and 1 or absolute_progress
    local x_progress = munchie.x_ease(absolute_progress)
    local y_progress = munchie.y_ease(absolute_progress)
    
    munchie.x = munchie.start_x + (x_progress * (munchie.end_x - munchie.start_x))
    munchie.y = munchie.start_y + (y_progress * (munchie.end_y - munchie.start_y))

    if absolute_progress == 1 then
        if not munchie.bonk then
            if mouth_open and alive then
                if munchie.sprite == M_BOMB then
                    sfx(2)
                    explode_until = t() + 0.125
                    alive = false
                    top_score = score > top_score and score or top_score
                else
                    sfx(0)
                    score += 1
                    toss_interval -= 0.01
                    toss_interval = toss_interval > MIN_TOSS_INTERVAL and toss_interval or MIN_TOSS_INTERVAL
                    chew_until = t() + CHEW_DURATION
                end
                return false
            else
                sfx(1)
                munchie.bonk = true
                munchie.start_time = t()
                munchie.end_time = t() + 0.125
                munchie.start_x = munchie.x
                munchie.start_y = munchie.y
                munchie.end_y = 64
                munchie.end_x = rnd({ -17, 128 + 17 })
                munchie.x_ease = x_ease_bonk
                munchie.y_ease = y_ease_bonk
            end
        else
            return false
        end
    end

    return true
end

function _munchie_draw(munchie)
    pal_all(0)
    spr(munchie.sprite, munchie.x+1, munchie.y, 2, 2, munchie.flipx)
    spr(munchie.sprite, munchie.x-1, munchie.y, 2, 2, munchie.flipx)
    spr(munchie.sprite, munchie.x, munchie.y+1, 2, 2, munchie.flipx)
    spr(munchie.sprite, munchie.x, munchie.y-1, 2, 2, munchie.flipx)
    pal()
    spr(munchie.sprite, munchie.x, munchie.y, 2, 2, munchie.flipx)
end

function make_munchie(start_x)
    local munchie = {}

    munchie.bonk = false
    munchie.update = _munchie_update
    munchie.draw = _munchie_draw
    munchie.start_time = t()
    munchie.sprite = rnd(M_FOOD)
    munchie.flipx = rnd({true, false})
    munchie.end_time = t() + 1
    munchie.start_x = rnd({ 0, 128-16 })
    munchie.start_y = 20
    munchie.end_y = 128 - 24
    munchie.end_x = 64 - 8
    munchie.x = munchie.start_x
    munchie.y = munchie.start_y
    munchie.x_ease = x_ease_toss
    munchie.y_ease = y_ease_toss

    return munchie
end

-- y
function y_ease_toss(t)
	return 2.7*t*t*t-1.7*t*t
end

function y_ease_bonk(t)
	return t
end

 -- x
function x_ease_toss(t)
	return t
end

function x_ease_bonk(t)
	return t
end