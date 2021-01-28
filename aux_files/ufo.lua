--File conatins functions for ufo objects
--UFO are ships which hdont change print angle, and have a target angle independent of move angle

local Enemy_ship = require("aux_files.enemy_ship")

UFO = {sound = nil}

UFO.__index = UFO
setmetatable(UFO,ENEMY_SHIP)


function UFO:shootFunc()
    if self.shoot_if_player_notvis == true or self:isPlayerVisible() == true then
        self.weapon.target_angle = self:targetPlayer()
        self.weapon:shootFunc(self,ENEMY_PROJ)
    end
end

function UFO:printFunc()
    love.graphics.draw(self.icon,self.x,self.y,0,nil,nil,self.x_off,self.y_off)
end

function UFO:moveFunc(dt)
    self.sound:play()
    SHIP.moveFunc(self,dt)
end

function UFO:new(rand)
    local icon          = love.graphics.newImage("assets/img/ships/ufo.png")
    local o             = setmetatable(ENEMY_SHIP:new(rand,icon),UFO)
    o.weapon            = rand(1,4) < 4 and SINGLE_SHOT:new(rand,o.speed) or MULTI_SHOT:new(rand,o.speed)     
    o.weapon.proj_speed = o.speed *( 1.2 * rand() + 0.7)
    o.score             = 30
    o.sound             = love.audio.newSource("/assets/sounds/thruster/ufo_sound.ogg","static")
    o.weapon.sound:setVolume(0.3)
    o.sound:setVolume(0.1)
    return o
end


