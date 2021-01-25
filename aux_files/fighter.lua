--File contains functions for fighter objects
--Fighters are ships which have the ability to chase after teh player ship

local Enemy_ship = require("aux_files.enemy_ship")

FIGHTER = {}
FIGHTER.__index = FIGHTER
setmetatable(FIGHTER,ENEMY_SHIP)

function FIGHTER:chasePlayer()
    self.move_angle  = self:targetPlayer()
end

function FIGHTER:moveFunc(dt)
    self:chasePlayer(dt)
    ENEMY_SHIP.moveFunc(self,dt)
end

local function getFighterWeapon(rand,speed)
    local n = rand(1,10)
    if n < 6 then
        return SINGLE_SHOT:new(rand,speed)
    elseif n < 9 then
        return CIRCLE_SHOT:new(rand,speed)
    else
        return MULTI_SHOT:new(rand,speed)
    end
end

local function getFighterProjSpeed(rand,ship_speed)
    local speed = PLAYER.speed * (0.75 * rand() + 0.50)
    if speed <= ship_speed + 0.25 then
        speed = ship_speed * (0.75 + rand() * 0.50)
    end
    return speed
end

function FIGHTER:new(rand)
    local icon   = love.graphics.newImage("/assets/img/ships/fighter_" .. rand(1,2) .. ".png")
    local o      = setmetatable(ENEMY_SHIP:new(rand,icon),FIGHTER)
    o.score      = 25 
    o.thruster   = THRUSTER:new(o.x,o.y,o.move_angle,rand)
    o.speed      = rand(55,PLAYER.speed - 90)
    o.weapon     = getFighterWeapon(rand,o.speed) 
    o.weapon.proj_speed = getFighterProjSpeed(rand,o.speed)
    return o
end

