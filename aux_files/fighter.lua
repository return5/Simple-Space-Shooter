--File contains functions for fighter objects
--Fighters are ships which have the ability to chase after teh player ship

local Enemy_ship = require("aux_files.enemy_ship")

FIGHTER = {}
FIGHTER.__index = FIGHTER
setmetatable(FIGHTER,ENEMY_SHIP)

--if the fighter can chase the player then do so if player is visible, otherwise just move straight
function FIGHTER:chasePlayer(dt)
        self.move_angle  = self:targetPlayer()
        self:moveStraight(dt)
end

function FIGHTER:new(rand)
    local icon   = love.graphics.newImage("assets/img/ships/fighter_" .. rand(1,2) ..".png")
    local o      = setmetatable(ENEMY_SHIP:new(rand,icon),FIGHTER)
    local chase  = rand(1,3) < 3  
    o.move_func  = chase == true and FIGHTER.chasePlayer or SHIP.moveStraight
    o.score      = chase == true and 20 or 10
    o.thruster   = THRUSTER:new(o.x,o.y,o.move_angle,rand)
    o.shoot_func = rand(1,3) < 3 and SHIP.shootSingle or SHIP.shootCircle
    return o
end

