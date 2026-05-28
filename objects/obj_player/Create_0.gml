pal_swap_init_system(shd_pal_swapper)

enum states
{
	normal,
	crouch,
	jump,
	mach2,
	mach3,
	machslide,
	machturn,
	hitwall,
	turn,
	move,
	hit,
	stun,
	superjumpprep,
	superjump,
	freefallland,
	taunt,
	tumble,
	climbwall,
	groundpoundstart, // Unused
	groundpound,
	enterdoor,
	walkfront,
	grab,
	hauling,
	finishingblow,
	thrown,
	uppercut,
	hurt,
	ladder,
	buzzsaw,
	parry,
	surfing,
	diveboard,
    ski,
	skibounce,
	skirow,
	hammerattack,
	hammertwirl,
	snowball,
	snowballjump,
	snowballwall,
	skateboardintro,
	skateboard,
	skateboardmove,
	skateboardhitwall,
	skateboardramp,
	skateboardwall,
	skateboardaim,
	slip,
	coconutgun,
	coconutintro,
	coconutshoot,
	coconutjump,
	noclip,
	gunk,
	gunkMove,
	gunkIntro
}

enum characters
{
	mildred,
	milton
}

global.characters = {}
global.playerPaletteSurface = -4
function character_get_color(_palette, _index)
{
    var col = {
        main: #FFFFFF,
        secon: #FFFFFF,
    }
    
    // so i decided to make a buffer down there because surface_getpixel can be taxing from what ive read, this was lowk confusing at first but i managed to handle it
    if !surface_exists(global.playerPaletteSurface) {
        global.playerPaletteSurface = surface_create(sprite_get_width(_palette), sprite_get_height(_palette));
        
        surface_set_target(global.playerPaletteSurface);
        draw_clear_alpha(c_black, 0);
        draw_sprite(_palette, 0, 0, 0);
        surface_reset_target();
        
       
        var _w = surface_get_width(global.playerPaletteSurface);
        var _h = surface_get_height(global.playerPaletteSurface);
        global.playerPaletteBuffer = buffer_create(_w * _h * 4, buffer_fixed, 1);
        buffer_get_surface(global.playerPaletteBuffer, global.playerPaletteSurface, 0);
    }
    
    
    if buffer_exists(global.playerPaletteBuffer) {
        var _w = surface_get_width(global.playerPaletteSurface);
        

        var _offset_main = ((2 * _w) + _index) * 4; 
        var _offset_secon = ((5 * _w) + _index) * 4;
        
        
        buffer_seek(global.playerPaletteBuffer, buffer_seek_start, _offset_main);
        var _r1 = buffer_read(global.playerPaletteBuffer, buffer_u8);
        var _g1 = buffer_read(global.playerPaletteBuffer, buffer_u8);
        var _b1 = buffer_read(global.playerPaletteBuffer, buffer_u8);
        col.main = make_color_rgb(_r1, _g1, _b1);
        
        
        buffer_seek(global.playerPaletteBuffer, buffer_seek_start, _offset_secon);
        var _r2 = buffer_read(global.playerPaletteBuffer, buffer_u8);
        var _g2 = buffer_read(global.playerPaletteBuffer, buffer_u8);
        var _b2 = buffer_read(global.playerPaletteBuffer, buffer_u8);
        col.secon = make_color_rgb(_r2, _g2, _b2);
    }
    
    return col;
}

global.characters[characters.mildred] =
{
	sprites: get_characterspr(characters.mildred),
	mainColors: {}
}

character = characters.mildred
sprites = global.characters[character].sprites.player
palette_index = 1

isMildred = true
isMilton = false

depth = -50
image_speed = 0.35
scr_collision_init()
grav = 0.5
if !variable_global_exists("saveroom")
{
	global.saveroom = ds_list_create()
	global.escaperoom = ds_list_create()
	global.followers = ds_list_create()
	global.collect = 0
	global.secretCount = 0
	global.treasure = false
	global.resetRoom = noone
	global.pumpkins = {
		count: 0, 
		amount: 12, 
		activeStein: false}
	global.patternSpr = spr_playerPat_threads
	
	global.escape = 
	{
		active: false,
		timer: (60 * 60) * 2,
		party: false,
	}
	
	global.combo = {
		dropped: false,
		amt: 0,
		timer: 60,
		previouscombo: 0,
		savecombo: 0,
		highest: 0,
	}
	
	global.toppins = {
		bean: false,
		cup: false,
		lime: false,
		bag: false,
		orange: false,
	}
	global.level_timer = 0
	global.save_timer = 0
	global.debug = false
	global.level = noone
	global.key = false
	global.prankenemy_killed = false
	global.prankenemy_cankill = true
	global.detective = false
	global.taunt_count = 0
	global.waybackIntro = false
	global.damage_count = 0
	global.has_paint = false
	global.painting_count = 0
	global.painting_max = 0
	global.can_enter_bus = false
}

jumpstop = false
door = "A"
state = states.normal
movespeed = 0
verticalMovespeed = 0
xscale = 1
xscaleMulti = 1
yscaleMulti = 1
poletreeID = noone

chargeeffect = -4
buffers = {}
buffers.step = 0
buffers.bigdashcloud = 0
buffers.idle = 60 * 3
buffers.afterimageMach = 0
buffers.afterimageBlur = 0
buffers.dashcloud = 0
buffers.crazyothereffect = 0
buffers.breakdanceheld = 0
buffers.notes = 0
buffers.hammer = 0
breakdancespeed = 0
breakdanceID = -4
jumpBuffer = false
slapBuffer = false
downBuffer = false

flash = false
rainbow = 0

super = false

soundsOk = FMODcreate_event("event:/Sfx/Player/yeag")
soundsLaugh = FMODcreate_event("event:/Sfx/Player/yay")
soundsHurt = FMODcreate_event("event:/Sfx/Player/gaey")
soundsMach = FMODcreate_event("event:/Sfx/Player/mach")
soundsSuperjump = FMODcreate_event("event:/Sfx/Player/superjump")
soundsRoll = FMODcreate_event("event:/Sfx/Player/tumble")
soundsGroundpound = FMODcreate_event("event:/Sfx/Player/groundpound")
soundGrab = FMODcreate_event("event:/Sfx/Player/dash")
soundsHammer = FMODcreate_event("event:/Sfx/Player/hammerattack")
soundsHammerAir = FMODcreate_event("event:/Sfx/Player/hammerair")
soundsSkateboard = FMODcreate_event("event:/Sfx/Player/Transformations/Skateboard/move")
soundsSkateAim = FMODcreate_event("event:/Sfx/Player/Transformations/Skateboard/aim")
soundsBuzzsaw = FMODcreate_event("event:/Sfx/Player/airspin")
spinsndbuffer = 0
speedlineseffect = -4
spinnyeffect = -4
hitstun = {}
hitstun.x = x
hitstun.y = y
hitstun.time = 0
hitstun.is = false
roomstartX = x
roomstartY = y

hallway = false
hallwayDirection = xscale
instakill = false

tauntVars = {
	sprite_index: sprite_index,
	image_index : image_index,
	state: state,
	vsp: vsp,
	hsp: hsp,
	movespeed: movespeed,
	image_speed: image_speed
}
tauntTimer = 0

freefallsmash = -4
crouchslip = 0
wallgrab = 0

enemyID = -4
i_frame = 0
coyote_time = 0
mach4mode = false
movespeedSurfing = 0
diveboardSaved = {}
diveboardSaved.movespeed = movespeed
diveboardSaved.state = state
diveboardSaved.sprite_index = sprite_index
diveboardSaved.image_index = image_index
diveboardSaved.y = y

backtohubRoom = room
backtohubX = x
backtohubY = y

prevOnSlope = false
onSlope = false
slopeObj = -4
wasRamp = false 
aimTime = 0
canHit = true
sprayCans = 4
skatespeed = 13

supertaunt = 0
canSupertaunt = false

squashX = 1
squashY = 1
freefalling = 0
swingdingendcooldown = 20
soundtestroom = room

gunkHard = 60

get_input()
alarm[1] = irandom_range(5, 15)

blend = c_white
blendAmount = 0
blendSpeed = 0.35 / 17
poison = 0

//the old code was creating two brand-new arrays in the game's memory 60 times every second causing some lag, rest of the fix is in the step code
spinnySprites_list = [spr_player_swingading, spr_milton_hammerspin, spr_player_superjumpcancel];
spinnySpritesV_list = [spr_player_buzzsaw, spr_player_buzzsawBump, spr_player_buzzsawFastFall, spr_milton_dive];
