--File contains functions for power up objects

local Obj = require("aux_files.object")

POWER_UP = {power_func = nil, sound = nil}
POWER_UP.__index = POWER_UP
setmetatable(POWER_UP,OBJECT)

local POWERUP_TYPES = {"Restore-Health","Temp-Health","Multi-Shot","Speed","Circle-Shot","Mouse-Target"}
local POWERUP_FUNCS = {POWERUP.restoreHealth,POWERUP.tempHealth,POWERUP.multiShot,POWERUP.speed,POWERUP.circleShot,POWERUP.mouseTarget}
local POWERUP_icons = {"restorehealth.png","temphealth.png","multishot.png","speed.png","circleshot.png","mousetarget.png"}

local function getPowerUpType(rand)
    return POWERUP_TYPES[rand(1,#POWERUP_TYPES)]
end

function POWERUP:restoreHealth(ship)
    ship:changeHelath(2)
    ship:checkHealth()
end

function POWERUP:tempHealth(ship)
    --tweening
    player:changeHelath(3)
end

function POWERUP:mouseTarget(ship)
    --tweening
    ship.target_mouse = true
end

function POWERUP:mulitShot(ship)

end

function POWERUP:speed(ship)

end

function POWERUP:circleShot(ship)

end

local function getPowerUpFunc(powerup_type)
    for i=1, #POWERUP_TYPES,1 do
        if powerup_type == POWERUP_TYPES[i] then
            return POWERUP_FUNCS[i]
        end
    end
    return nil
end

local function getPowerUpIcons(powerup_type)
    for i=1, #POWERUP_TYPES,1 do
        if powerup_type == POWERUP_TYPES[i] then
            return love.graphics.newImage("assets/img/powerups/ " .. POWERUP_ICONS[i])
        end
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

