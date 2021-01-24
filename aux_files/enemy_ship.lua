--File contains functions for delaing with Enemy ship objects
--ENEMY_SHIPS are ships which can shoot at the player

local Ship   = require("aux_files.ship")
local Weapon = require("aux_files.weapon")


ENEMY_SHIP = {score = nil,time_since_seen = nil,shoot_if_player_notvis = nil,target_angle = nil,weapon = nil}
ENEMY_SHIP.__index = ENEMY_SHIP
setmetatable(ENEMY_SHIP,SHIP)


function ENEMY_SHIP:printFunc()
    OBJECT.printFunc(self)
    self:printThruster()
end

--look at a random spot near player position
function ENEMY_SHIP:targetPlayer()
    if self:isPlayerVisible() == true and love.timer.getTime() - self.time_since_seen > 2 then
        self.target_x    = math.random(PLAYER.x - 10, PLAYER.x + 10)
        self.target_y    = math.random(PLAYER.y - 10,PLAYER.y + 10)
        self.time_since  = love.timer.getTime()
        return self:getNewTargetAngle()
    end
    return self.target_angle
end

local function getProjSpeed(rand,ship_speed)
    local speed =  (.5 + rand() * .25) * PLAYER.speed
    if speed < ship_speed then
        speed = ship_speed * 1.5
    end
    return speed
end

function ENEMY_SHIP:moveFunc(dt)
    if self:getNewXY(dt) == false then
        self.move_angle = self:getNewRandomMoveAngle()
    end
end

function ENEMY_SHIP:new(rand,icon)
    local o                  = setmetatable(SHIP:new(rand,icon),ENEMY_SHIP)
    o.time_between_shots     = 0.75 + rand() * 1.5
    o.time_since_seen        = o.time_since_shot
    o.proj_speed             = getProjSpeed(rand,o.speed)
    o.shoot_if_player_notvis = rand(1,3) < 3 
    o.target_angle           = o.move_angle
    return o
end


