--File contains functions for power up objects

local Obj = require("aux_files.object")

POWER_UP = {power_func = nil, sound = nil}
POWER_UP.__index = POWER_UP
setmetatable(POWER_UP,OBJECT)

local POWERUP_TYPES = {"Restore-Health","Temp-Health","Multi-Shot","Speed","Circle-Shot","Mouse-Target"}

local function getPowerUpType(rand)
    return POWERUP_TYPES[rand(1,#POWERUP_TYPES)]
end

local function getPowerUpIcon(powerup_type)
    if powerup_type == POWERUP_TYPES[1] then

    elseif powerup_type == POWERUP_TYPES[2] then

    elseif powerup_type == POWERUP_TYPES[3] then

    elseif powerup_type == POWERUP_TYPES[4] then

    elseif powerup_type == POWERUP_TYPES[5] then

    elseif powerup_type == POWERUP_TYPES[6] then

    end
    return nil
end

local function getPowerUpFunc(powerup_type)
    if powerup_type == POWERUP_TYPES[1] then

    elseif powerup_type == POWERUP_TYPES[2] then

    elseif powerup_type == POWERUP_TYPES[3] then

    elseif powerup_type == POWERUP_TYPES[4] then

    elseif powerup_type == POWERUP_TYPES[5] then

    elseif powerup_type == POWERUP_TYPES[6] then

    end
    return nil

end

function POWER_UP:new()
    local rand         = math.random
    local powerup_type = getPowerUpType(rand)
    local icon         = getPowerUpIcon(powerup_type)
    local x,y          = makeXY(PWER_UP_LIST,rand)
    local o            = setmetatable(OBJECT:new(x,y,0,icon),POWER_UP)
    o.func             = getPowerUpFunc(powerup_type)
    return o
end

