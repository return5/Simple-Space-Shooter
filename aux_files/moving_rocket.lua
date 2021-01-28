
--File deals with moving rocket ships

local Enemy_ship = require("aux_files.enemy_ship")

MOVING_ROCKET = {}
MOVING_ROCKET.__index = MOVING_ROCKET
setmetatable(MOVING_ROCKET,ENEMY_SHIP)

function MOVING_ROCKET:new(rand) 
    local icon = love.graphics.newImage("/assets/img/ships/rocket.png")
    local o    = setmetatable(ENEMY_SHIP:new(rand,icon),MOVING_ROCKET)
    o.weapon   = SINGLE_SHOT:new(rand,o.speed)
    o.health   = 1
    o.score    = 5
    o.thruster = THRUSTER:new(o.x,o.y,o.move_angle,rand)
    o.weapon.sound:setVolume(0.3)
    return o
end
