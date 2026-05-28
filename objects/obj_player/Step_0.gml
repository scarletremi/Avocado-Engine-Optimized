depth = 0
if FMODevent_isplaying(soundsOk)
	FMODSet3dPos(soundsOk, x, y)
if FMODevent_isplaying(soundsLaugh)
	FMODSet3dPos(soundsLaugh, x, y) 
if FMODevent_isplaying(soundsHurt)
	FMODSet3dPos(soundsHurt, x, y) 
var _insta = ( sprite_index == spr_player_swingading || state == states.slip || state == states.mach3 || state == states.skateboard || state == states.skateboardwall || state == states.skateboardramp || state == states.skateboardmove || state == states.hammerattack || (state == states.machturn && sprite_index == spr_player_mach3turn) || state == states.superjump  || state == states.uppercut || state == states.groundpound || state == states.groundpoundstart || state == states.buzzsaw || state == states.snowball || state == states.snowballjump || state == states.snowballwall)
instakill = _insta
if hitstun.is == false
{
	do_state() // state machine
	
	if !instance_exists(obj_technicaldifficulty) && obj_player.state != states.enterdoor && obj_player.state != states.skateboardintro && obj_player.state != states.walkfront && !instance_exists(obj_fadeout) && obj_player.state != -4
		global.combo.timer = max(global.combo.timer - 0.15, 0) 
	if global.combo.previouscombo != global.combo.amt
	{
		global.combo.previouscombo = global.combo.amt
		
		if global.combo.amt > 0 && ((global.combo.amt % 5) == 0)
		{
			instance_destroy(obj_comboTitle)
			with instance_create(811, 350, obj_comboTitle)
			{
				combo = floor(global.combo.amt / 5)
				if floor(global.combo.amt / 5) > 15
					very = true
				combo = wrap(combo, 0, 14)
				image_index = self.getProper(combo)
			}
			FMODevent_oneshot("event:/Sfx/UI/Combo/comboup")
		}
	}
	if global.combo.timer == 0 && global.combo.amt > 0
	{
		global.combo.savecombo = global.combo.amt
		if global.combo.savecombo > global.combo.highest
			global.combo.highest = global.combo.savecombo
		global.combo.amt = 0
		if !instance_exists(obj_rank)
		{
			if !global.combo.dropped
				FMODevent_oneshot("event:/Sfx/UI/Combo/prankfail")
			global.combo.dropped = true
			FMODevent_oneshot("event:/Sfx/UI/Combo/comboend")
			instance_destroy(obj_comboTitle)
			with instance_create(811, 350, obj_comboTitle)
			{
				combo = floor(global.combo.savecombo / 5)
				if floor(global.combo.savecombo / 5) > 15
					very = true
				lostcombo = true
				combo = wrap(combo, 0, 14)
				image_index = self.getProper(combo)
				points = round(((global.combo.savecombo ^ 2) * 0.25) + (10 * global.combo.savecombo))
				global.collect += points
				alarm[1] = 30
			}
		}
	}
	scr_collision()
	scr_collide_destructibles()
if array_contains(spinnySprites_list, sprite_index)
{
    if !instance_exists(spinnyeffect)
        spinnyeffect = instance_create(x, y, obj_spinnyeffect);
        
    with spinnyeffect 
    { 
        targetSprite = other.sprite_index;
        sprite_index = spr_spinnyeffect;
    }
}

if array_contains(spinnySpritesV_list, sprite_index)
{
    if !instance_exists(spinnyeffect)
        spinnyeffect = instance_create(x, y, obj_spinnyeffect);
        
    with spinnyeffect 
    {
        targetSprite = other.sprite_index;
        sprite_index = spr_spinnyeffect_vertical;
    }
}
	if grounded
		coyote_time = 10
	else if vsp < 0
		coyote_time = 0
	coyote_time--
	if state != states.hurt
		i_frame = approach(i_frame, 0, 1)
	if i_frame > 0 && state != states.hurt
		image_alpha = round(wave(0, 1, 0.05, 0))
	else
		image_alpha = 1
	
	
	image_blend = merge_colour(blend, c_black, blendAmount)
	blendAmount = max(blendAmount - blendSpeed, 0)
	poison = max(poison - 60 / (60 * 3), 0)
	if poison == 0
	{
		if blend = #a3ed99
		{
			blend = c_white
			flash = true
		}
	}
	if poison > 0 && alarm[2] <= 0
		alarm[2] = 30
	
	if flash = true && alarm[0] <= 0
		alarm[0] = 5
	
	if global.combo.amt >= 15 && alarm[3] <= 0
		alarm[3] = 10
	if y < -500 || y > room_height + 500 && state != -4 && !instance_exists(obj_fadeout)
	{
		if !instance_exists(obj_technicaldifficulty)
		{
			instance_create(x, y, obj_technicaldifficulty) 
			shake_camera(3, 3)
			FMODevent_oneshot("event:/Sfx/Player/slam", x, y)
		}
	}
	if state == states.crouch || state == states.tumble || state == states.superjumpprep
		mask_index = spr_crouchmask
	else
		mask_index = spr_player_mask
}
else {
	get_input()
	if hitstun.time > 0
	{
		image_speed = 0
		x = hitstun.x + irandom_range(-5, 5)
		y = hitstun.y + irandom_range(-5, 5)
		hitstun.time--
		if instance_exists(obj_fadeout)
		{
			hitstun.time = 0
			x = hitstun.x
			y = hitstun.y
			hitstun.is = false
		}
	}
	else {
		x = hitstun.x
		y = hitstun.y
		hitstun.is = false
	}
}
