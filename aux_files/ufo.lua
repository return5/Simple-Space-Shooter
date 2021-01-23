--File conatins functions for ufo objects
--UFO are ships which hdont change print angle, and have a target angle independent of move angle

local Enemy_ship = require("aux_files.enemy_ship")

UFO = {move_target_x = nil, move_target_y = nil}

UFO.__index = UFO
setmetatable(UFO,ENEMY_SHIP)


function UFO:shootFunc()
    if self.shoot_if_player_notvis == true or self:isPlayerVisible() == true then
        self.target_angle = self:targetPlayer()
        self:shootSingle(ENEMY_PROJ)
    end
end

function UFO:printFunc()
    love.graphics.draw(self.icon,self.x,self.y,0,nil,nil,self.x_off,self.y_off)
end

function UFO:moveFunc(dt)
    self:moveStraight(dt)
end 

function UFO:new(rand)
    local icon        = love.graphics.newImage("assets/img/ships/ufo.png")
    local o           = setmetatable(ENEMY_SHIP:new(rand,icon),UFO)
    o.shoot_target_x  = rand(1,GAME_W)
    o.shoot_target_y  = rand(1,GAME_H)
    return o
end


