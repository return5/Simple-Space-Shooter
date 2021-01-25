--File deals with stationary rocket ships


local Stationary = require("aux_files.stationary")
STATIONARY_ROCKET = {}
STATIONARY_ROCKET.__index = STATIONARY_ROCKET
setmetatable(STATIONARY_ROCKET,STATIONARY)

local function getStationaryRocketWeapon(rand)
    local n = rand(0,5)
    if n < 3 then
        return SINGLE_SHOT:new(rand,0)
    elseif n < 5 then
        return CIRCLE_SHOT:new(rand,0)
    else
        return MULTI_SHOT:new(rand,0)
    end
end

function STATIONARY_ROCKET:new(rand) 
    local icon = love.graphics.newImage("/assets/img/ships/rocket.png")
    local o    = setmetatable(STATIONARY:new(rand,icon),STATIONARY_ROCKET)
    o.weapon   = getStationaryRocketWeapon(rand)
    o.health   = 1
    o.score    = 10
    return o
end

