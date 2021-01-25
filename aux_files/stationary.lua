--File deals with stationary objects

local Enemy_ship = require("aux_files.enemy_ship")

STATIONARY = {}
STATIONARY.__index = STATIONARY
setmetatable(STATIONARY,ENEMY_SHIP)

function STATIONARY:moveFunc(dt)
    self.move_angle = self:targetPlayer()
end

function STATIONARY:new(rand,icon)
    local o  = setmetatable(ENEMY_SHIP:new(rand,icon),STATIONARY)
    return o
end

