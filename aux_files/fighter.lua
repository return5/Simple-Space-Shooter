--File contains functions for fighter objects
--Fighters are ships which have the ability to chase after teh player ship

local Enemy_ship = require("aux_files.enemy_ship")

FIGHTER = {chase = nil}
FIGHTER.__index = FIGHTER
setmetatable(FIGHTER,ENEMY_SHIP)

--if the fighter can chase the player then do so if player is visible, otherwise just move straight
function FIGHTER:chasePlayer()
        self.move_angle  = self:targetPlayer()
end

function FIGHTER:moveFunc(dt)
    if self.chase == true then
        self:chasePlayer(dt)
    end
        ENEMY_SHIP.moveFunc(self,dt)
end

function FIGHTER:new(rand)
    local icon   = love.graphics.newImage("assets/img/ships/fighter_" .. rand(1,2) ..".png")
    local o      = setmetatable(ENEMY_SHIP:new(rand,icon),FIGHTER)
    o.chase      = false--rand(1,3) < 3  
    o.score      = chase == true and 20 or 10
    o.thruster   = THRUSTER:new(o.x,o.y,o.move_angle,rand)
    o.speed      = rand(55,MAX_SPEED - 90)
    o.weapon     = SINGLE_SHOT:new(rand,o.speed)
    return o
end

