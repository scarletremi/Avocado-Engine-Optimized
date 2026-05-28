var camx = camera_get_view_x(view_camera[0]);
var camy = camera_get_view_y(view_camera[0]);
var layers = layer_get_all();
for (var i = 0; i < array_length(layers); i++)
{
	var lay = layers[i];
	var layer_name = layer_get_name(lay);
	var tile_id = layer_tilemap_get_id(lay);
	
	switch layer_name
	{
		case "Foregrounds_1":
			layer_x(lay, camx * -0.15);
			layer_y(lay, camy * -0.15);
		break
		case "Backgrounds_1":
			layer_x(lay, camx * 0.15);
			layer_y(lay, camy * 0.15);
		break
		case "Backgrounds_2":
			layer_x(lay, camx * 0.25);
			layer_y(lay, camy * 0.25);
		break
		case "Backgrounds_3":
			layer_x(lay, camx * 0.35);
			layer_y(lay, camy * 0.35);
		break
		case "Backgrounds_4":
			layer_x(lay, camx * 0.45);
			layer_y(lay, camy * 0.45);
		break
		case "Backgrounds_still1":
			var lay_id = layer_get_id(layer_name);
			var back_id = layer_background_get_id(lay_id);
			if sprite_get_width(layer_background_get_sprite(back_id)) > SCREEN_WIDTH
			{
				var amt = sprite_get_width(layer_background_get_sprite(back_id)) - SCREEN_WIDTH
				layer_x(lay, camx - (camx / room_width) * amt);
			}
			else
				layer_x(lay, camx);
			if sprite_get_height(layer_background_get_sprite(back_id)) > SCREEN_HEIGHT
			{
				var amt = sprite_get_height(layer_background_get_sprite(back_id)) - SCREEN_HEIGHT
				layer_y(lay, camy - (camy / room_height) * amt);
			}
			else
				layer_y(lay, camy);
		break
		case "Backgrounds_still2":
			var lay_id = layer_get_id(layer_name);
			var back_id = layer_background_get_id(lay_id);
			if sprite_get_width(layer_background_get_sprite(back_id)) > SCREEN_WIDTH
			{
				var amt = sprite_get_width(layer_background_get_sprite(back_id)) - SCREEN_WIDTH
				layer_x(lay, camx - (camx / room_width) * amt);
			}
			else
				layer_x(lay, camx);
			if sprite_get_height(layer_background_get_sprite(back_id)) > SCREEN_HEIGHT
			{
				var amt = sprite_get_height(layer_background_get_sprite(back_id)) - SCREEN_HEIGHT
				layer_y(lay, camy - (camy / room_height) * amt);
			}
			else
				layer_y(lay, camy);
		break
		case "Backgrounds_stillH1":
			layer_x(lay, camx * 0.15);
			var lay_id = layer_get_id(layer_name);
			var back_id = layer_background_get_id(lay_id);
			if sprite_get_height(layer_background_get_sprite(back_id)) > SCREEN_HEIGHT
			{
				var amt = sprite_get_height(layer_background_get_sprite(back_id)) - SCREEN_HEIGHT
				layer_y(lay, camy - (camy / room_height) * amt);
			}
			else
				layer_y(lay, camy);
		break
		case "Backgrounds_stillH2":
			layer_x(lay, camx * 0.25);
			var lay_id = layer_get_id(layer_name);
			var back_id = layer_background_get_id(lay_id);
			if sprite_get_height(layer_background_get_sprite(back_id)) > SCREEN_HEIGHT
			{
				var amt = sprite_get_height(layer_background_get_sprite(back_id)) - SCREEN_HEIGHT
				layer_y(lay, camy - (camy / room_height) * amt);
			}
			else
				layer_y(lay, camy);
		break
		case "Backgrounds_stillH3":
			layer_x(lay, camx * 0.35);
			var lay_id = layer_get_id(layer_name);
			var back_id = layer_background_get_id(lay_id);
			if sprite_get_height(layer_background_get_sprite(back_id)) > SCREEN_HEIGHT
			{
				var amt = sprite_get_height(layer_background_get_sprite(back_id)) - SCREEN_HEIGHT
				layer_y(lay, camy - (camy / room_height) * amt);
			}
			else
				layer_y(lay, camy);
		break
		case "Backgrounds_stillH4":
			layer_x(lay, camx * 0.45);
			var lay_id = layer_get_id(layer_name);
			var back_id = layer_background_get_id(lay_id);
			if sprite_get_height(layer_background_get_sprite(back_id)) > SCREEN_HEIGHT
			{
				var amt = sprite_get_height(layer_background_get_sprite(back_id)) - SCREEN_HEIGHT
				layer_y(lay, camy - (camy / room_height) * amt);
			}
			else
				layer_y(lay, camy);
		break
		case "Backgrounds_stillH5":
			layer_x(lay, camx * 0.55);
			var lay_id = layer_get_id(layer_name);
			var back_id = layer_background_get_id(lay_id);
			if sprite_get_height(layer_background_get_sprite(back_id)) > SCREEN_HEIGHT
			{
				var amt = sprite_get_height(layer_background_get_sprite(back_id)) - SCREEN_HEIGHT
				layer_y(lay, camy - (camy / room_height) * amt);
			}
			else
				layer_y(lay, camy);
		break
		case "Foregrounds_ground1":
			layer_x(lay, camx * -0.25);
			layer_y(lay, room_height - SCREEN_HEIGHT);
		break
		case "Backgrounds_groundscroll1":
			layer_x(lay, camx * -0.15 + (layer_get_hspeed(lay) * current_time / 30));
			layer_y(lay, room_height - SCREEN_HEIGHT);
		break
		case "Backgrounds_stillscroll1":
			layer_x(lay, camx + (layer_get_hspeed(lay) * current_time / 30));
			layer_y(lay, camy + (layer_get_vspeed(lay) * current_time / 30));
		break
		case "Backgrounds_stillscroll2":
			layer_x(lay, camx + (layer_get_hspeed(lay) * current_time / 30));
			layer_y(lay, camy + (layer_get_vspeed(lay) * current_time / 30));
		break
		case "Assets_bg1":
			layer_x(lay, camx * 0.01);
			layer_y(lay, camy * 0.01);
		break
		case "Backgrounds_waveH1":
			layer_x(lay, wave(0, 50, 4, 10) + (layer_get_hspeed(lay) * current_time / 5) * 0.15)
			layer_y(lay, (layer_get_vspeed(lay) * current_time / 5) * 0.15);
		break
		case "Backgrounds_waveV1":
			layer_x(lay, (layer_get_hspeed(lay) * current_time / 5) * 0.15)
			layer_y(lay, wave(0, 50, 4, 10) + (layer_get_vspeed(lay) * current_time / 5) * 0.15)
		break
		case "Backgrounds_zigzag1":
			layer_x(lay, (layer_get_hspeed(lay) * current_time / 5) * 0.15)
			layer_y(lay, wave(0, 50, 8, 10) + (layer_get_vspeed(lay) * current_time / 5) * 0.15)
		break
	}
}
	escape_background(bg_beakerBack, bg_beakerBack_escape)
	escape_background(bg_beakerBackTrees, bg_beakerBackTrees_escape)
	escape_background(bg_beakerTrees, bg_beakerTrees_escape)
	escape_background(bg_beakerBushes, bg_beakerBushes_escape)
	escape_background(bg_beakerForestTop1, bg_beakerForestTop1_escape)
	escape_background(bg_beakerForestTop2, bg_beakerForestTop2_escape)
	escape_background(bg_beakerForestTop3, bg_beakerForestTop3_escape)
	escape_background(bg_beakerFrontier, bg_beakerFrontier_escape)
	escape_background(bg_temple1, bg_temple_escape1)
	escape_background(bg_temple2, bg_temple_escape2)
	escape_background(bg_temple3, bg_temple_escape3)
	
	//all i did was move the escape backgrounds outside of the loop 
