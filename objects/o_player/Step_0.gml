var left_key  = keyboard_check( ord("A") )
var right_key = keyboard_check( ord("D") )

var jump_key        = keyboard_check( vk_space )
var jump_key_rel    = keyboard_check_released( vk_space )
var jump_key_tap    = keyboard_check_pressed( vk_space )
    
xInput = right_key - left_key
isMoving = (xInput != 0)
isGround = place_meeting(x, y+1, global.tag_player_collide)

// velocity
xVel = (xInput * moveSpd) * can_move
yVel += grav

// Jumping
isJumping = jump_key * (jump_timer < jump_max_time)
if (jump_key_rel) {
    can_jump = false
}

if (isGround) {
    jump_timer = 0
    can_jump = true
}

if (isJumping && can_jump) {
    jump_timer += global.dt_sec * isJumping
    jump_timer = clamp(jump_timer, 0, jump_max_time)
    var jump_t = inverse_lerp(jump_timer, 0, jump_max_time)
    yVel = -(jump_force * (1 + lerp(0, jump_max_force_mult, 1 - jump_t)))
}


// Collision checks
var sub_pixel = 0.25 * sign(xVel)
if (place_meeting(x + xVel, y, global.tag_player_collide)) {
    while (!place_meeting(x + sub_pixel, y, global.tag_player_collide)) {
        x += sub_pixel
    }
    xVel = 0
}

sub_pixel = 0.25 * sign(yVel)
if (place_meeting(x, y + yVel, global.tag_player_collide)) {
	while (!place_meeting(x, y + sub_pixel, global.tag_player_collide)) {
        y += sub_pixel
    }
    yVel = 0
}

x += xVel
y += clamp(yVel, -200, max_fall_spd)