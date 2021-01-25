--File deals with space stations

local Stationary = require("aux_files.stationary")

STATION ={}
STATION.__index = STATION
setmetatable(STATION,STATIONARY)

local function getStationIcon(rand)
    return love.graphics.newImage("assets/img/ships/Space_Station_" .. rand(1,3) ..".png")
end

local function getStationWeapon(rand)
    local n = rand(0,5)
    if n < 3 then
        return SINGLE_SHOT:new(rand,0)
    elseif n < 5 then
        return MULTI_SHOT:new(rand,0)
    else
        return CIRCLE_SHOT:new(rand,0)
    end
end

function STATION:new(rand) 
    local icon = getStationIcon(rand)
    local o    = setmetatable(STATIONARY:new(rand,icon),STATION)
    o.health   = 3
    o.score    = 20
    o.weapon   = getStationWeapon(rand)
    return o
end

