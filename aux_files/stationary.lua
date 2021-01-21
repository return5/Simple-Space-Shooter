--File deals with stationary objects

local Enemy_ship = require("aux_files.enemy_ship")

STATIONARY = {}
STATIONARY.__index = STATIONARY
setmetatable(STATIONARY,ENEMY_SHIP)


local function getStationaryType(rand) 
    return rand(1,3) < 3 and "Station" or "Rocket"
end

local function getStationaryIcon(s_typ,rand) 
    local icon = s_type == "Rocket" and "assets/img/ships/rocket.png" or "assets/img/ships/Space_Station_" .. rand(1,3) .. ".png"
    return love.graphics.newImage(icon)
end

local function getStationaryShootFunc(s_type,rand)
    local func
    if s_type == "Rocket" then
        func = SHIP.shootSingle
    else
        func = rand(1,3) < 3 and SHIP.shootSingle or SHIP.shootCircle
    end
    return func
end

function STATIONARY:new(rand)
    local s_type = getStationaryType(rand) 
    local icon   = getStationaryIcon(s_typ,rand) 
    local o      = setmetatable(ENEMY_SHIP:new(rand,icon),STATIONARY)
    o.move_func  = ENEMY_SHIP.targetPlayer
    o.shootFunc  = getStationaryShootFunc(s_type,rand)
    o.print_func = OBJECT.printObj
    return o
end

