--File conatins functions for ufo objects

local Enemy_ship = require("aux_files.enemy_ship")

UFO = {shoot_target_x = nil, shoot_target_y = nil}

UFO.__index = UFO
setmetatable(UFO,ENEMY_SHIP)

function UFO:getNewTarget()
    self.shoot_target_x = PLAYER.x
    self.shoot_target_y = PLAYER.y
end

function ufoShoot(list,ship)
    local vis = ship:isPlayerVisible()
    if vis == true then
        ship:getNewTarget()
    end
    if ship.shoot_if_player_notvis == true or vis == true then
        local m_angle = ship.move_angle
        ship.move_angle = math.atan2(ship.shoot_target_y - ship.y,ship.shoot_target_x - ship.x)
        shootSingle(ENEMY_PROJ,ship)
        ship.move_angle = m_angle
    end
end


function UFO:new(rand,ship_type)
    local o = setmetatable(ENEMY_SHIP:new(rand,ship_type),UFO)
    o.shoot_func = ufoShoot
    o.shoot_target_x  = rand(1,GAME_W)
    o.shoot_target_y  = rand(1,GAME_H)
    return o
end


