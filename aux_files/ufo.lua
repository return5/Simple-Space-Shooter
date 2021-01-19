--File conatins functions for ufo objects

local Enemy_ship = require("aux_files.enemy_ship")

UFO = {shoot_target_x = nil, shoot_target_y = nil}

UFO.__index = UFO
setmetatable(UFO,ENEMY_SHIP)


function ufoShoot(list,ship)
    lookAtPlayer(ship)
    if ship.shoot_if_player_notvis == true or ship:isPlayerVisible() == true then
        shootSingle(ENEMY_PROJ,ship)
    end
end


function UFO:new(rand,ship_type)
    local o = setmetatable(ENEMY_SHIP:new(rand,ship_type),UFO)
    o.shoot_func = ufoShoot
    o.shoot_target_x  = rand(1,GAME_W)
    o.shoot_target_y  = rand(1,GAME_H)
    return o
end


