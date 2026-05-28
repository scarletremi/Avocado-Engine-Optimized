//casually rewrites sum of the collision stuff, also i fucked up some of the brackets so i lowk wasted some time

function scr_collision_init()
{
    vsp = 0;
    hsp = 0;
    grav = 0;
    grounded = false;
    coyote_time = 0;
    can_coyote = true;
}

function scr_collision()
{
    grounded = false
    var o_x = x, o_y = y
    if vsp < 20
        vsp += grav
    var finalHsp = hsp
    var finalVsp = vsp
    
  
    repeat round(abs(finalVsp))
    {
        o_y = y
        if abs(finalVsp) != 0
            y += sign(finalVsp);
        else
            y += finalVsp;
        
        if scr_solid(x, y)
        {
            y = o_y
            vsp = 0
            finalVsp = 0
        }
    }
    
   
    repeat round(abs(finalHsp))
    {
        o_x = x
        if abs(finalHsp) != 0
            x += sign(finalHsp);
        else
            x += finalHsp;
            
        var inc = 8
        if vsp >= -1
        {
            for (var i = 0; i < inc; i++)
            {
                
                if !scr_solid(x, y - i) 
                {
                    var _loop_limit = 16; 
                    while (scr_solid(x, y) && _loop_limit > 0) {
                        y--;
                        _loop_limit--;
                    }
                }
                
                
                if scr_solid(x, y + i + 1) && scr_solid(x - sign(finalHsp), y + i) 
                {
                    var _loop_limit = 16;
                    while (!scr_solid(x, y + 1) && _loop_limit > 0) {
                        y++;
                        _loop_limit--;
                    }
                }
            }
        }
        
        if scr_solid(x, y)
        {
            x = o_x
            hsp = 0
            finalHsp = 0
        }
    }
    
    grounded |= scr_solid(x, y + 1)
    if grounded
        y = floor(y)
}

function scr_slope(_x, _y)
{
    var _collided = false
    with (instance_place(_x, _y, obj_slope))
        _collided = scr_slope_collideCheck(other.id, _x, _y)
    return _collided
}

function scr_solid(_x, _y)
{
    var _self_id = id
    var _collided = false
    var _collision_list = ds_list_create();
    var _collides_with = [obj_solid, obj_slope, obj_platform, obj_destructibles]
    
    for (var i = 0; i < array_length(_collides_with); i++)
    {
        var _num = instance_place_list(_x, _y, _collides_with[i], _collision_list, false);

        if _num > 0
        {
            for (var c = 0; c < _num; c++) 
            {
                var _obj_target = _collision_list[| c].object_index
                var _solid_type = _collides_with[i]
                if object_get_parent(_obj_target) == _solid_type || _obj_target == _solid_type
                {
                    with _collision_list[| c]
                    {
                        switch _solid_type
                        {
                            case obj_destructibles:
                            case obj_solid:
                                _collided = true
                                break
                            case obj_slope:
                                if scr_slope_collideCheck(_self_id, _x, _y)
                                    _collided = true
                                break
                            case obj_platform:
                                var _top = false
                                if sign(image_yscale) < 0
                                    _top = (_self_id.bbox_top - 1 >= bbox_top + 1) && _self_id.vsp <= 0
                                else
                                    _top = (_self_id.bbox_bottom - 1 <= bbox_top + 1) && _self_id.vsp >= 0
                                if _top
                                    _collided = true
                                break
                        }
                    }
                }
            }
        }
    }
    ds_list_destroy(_collision_list)
    return _collided;
}

function scr_slope_collideCheck(_playerId, _x, _y)
{
    var _player_height = _playerId.bbox_bottom - _playerId.y
    var _slope_angle = (bbox_bottom - bbox_top) / (bbox_right - bbox_left)
    var _side = _x + (_playerId.bbox_left - _playerId.x)
    var _slope = bbox_bottom + ((_side - bbox_right) * _slope_angle)
    if image_xscale > 0 // left faced slope
    {
        _side = _x + (_playerId.bbox_right - _playerId.x)
        _slope = bbox_bottom - ((_side - bbox_left) * _slope_angle)
    }
    if image_yscale < 0 // upside down
    {
        _player_height = _playerId.y - _playerId.bbox_top
        return _y + _player_height < bbox_top + (bbox_bottom - _slope)
    }
    return _y + _player_height > _slope
}
