function async_load_game()
{
    with obj_savesystem
    {
        if state == savesystem.idle
        {
            load_buff = buffer_create(1, buffer_grow, 1)
            buffer_async_group_begin("saves")
           
            buffer_load_async(load_buff, game_save_id + global.saveFile, 0, -1)
            
            save_id = buffer_async_group_end()
            state = savesystem.loading
        }
    }
}

function async_save_game()
{
    with obj_savesystem
    {
        if state == savesystem.idle
        {
            show_icon = true
            icon_alpha = 3
            buffer_async_group_begin("saves")
            save_buff = buffer_create(1, buffer_grow, 1)
            ini_open_from_string(ini_str)
            var _close_str = ini_close()
            buffer_write(save_buff, buffer_string, _close_str)
            
            buffer_save_async(save_buff, game_save_id + global.saveFile, 0, buffer_tell(save_buff))
            
            save_id = buffer_async_group_end()
            state = savesystem.saving
        }
    }
}

function async_save_options()
{
    with obj_savesystem
    {
        if state == savesystem.idle
        {
            show_icon = true
            icon_alpha = 3
            buffer_async_group_begin("saves")
            save_buff = buffer_create(1, buffer_grow, 1)
            ini_open_from_string(ini_str_options)
            var _close_str = ini_close()
            buffer_write(save_buff, buffer_string, _close_str)
            
           
            buffer_save_async(save_buff, game_save_id + "saveData.ini", 0, buffer_tell(save_buff))
            
            save_id = buffer_async_group_end()
            state = savesystem.saving
        }
    }
}
