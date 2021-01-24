--File contains functions for dealing with satellites

local Enemy_ship = require("aux_files.ship")

SATELLITE = {}
SATELLITE.__index = SATELLITE
setmetatable(SATELLITE,SHIP)

local function getSatelliteIcon(rand)
    return love.graphics.newImage("assets/img/ships/satellite_" .. rand(1,5) .. ".png")
end

function SATELLITE:shootFunc(dt)
    --do nothing
end

function SATELLITE:new(rand)
    local icon   = getSatelliteIcon(rand)
    local o      = setmetatable(SHIP:new(rand,icon),SATELLITE)
    o.score      = 5
    return o
end

