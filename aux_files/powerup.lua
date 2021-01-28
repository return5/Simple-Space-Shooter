--File contains functions for power up objects

local Weapon = require("aux_files.weapon")

POWERUP = {func = nil, sound = nil}
POWERUP.__index = POWERUP
setmetatable(POWERUP,OBJECT)

local POWERUP_ICONS = {"restore_health_powerup.png","temp_health_powerup.png","multi_shot_powerup.png","speed_boost_powerup.png","target_mouse_powerup.png"}

function restoreHealth(ship)
    ship:changeHealth(2)
    ship:checkHealth()
end

function tempHealth(ship)
    if ship.health <= 6 then
        ship.prev_health = ship.health
    end
    ship:changeHealth(math.huge)
    Tick.delay(Lume.once(function(ship) ship.health = ship.prev_health end,ship),10)
end

function mouseTarget(ship)
    ship.target_mouse    = true
    ship.weapon.time_between_shots = ship.time_between_shots * 0.4
    Tick.delay(Lume.once(function(ship)
        ship.target_mouse = false
        ship.weapon.time_between_shots = ship.prev_time_shots 
        ship.weapon.target_angle       = ship.move_angle
        end,ship),10)
end

function multiShot(ship)
    ship.weapon                    = MULTI_SHOT:new(math.random,ship.speed)
    ship.weapon.time_between_shots = ship.prev_time_shots
    Tick.delay(Lume.once(function(ship) ship.weapon = ship.prev_weapon end,ship),10)
end

function increaseSpeed(ship)
    ship.speed             = ship.prev_speed * 1.5
    ship.weapon.proj_speed = ship.prev_proj_speed * 1.5
    Tick.delay(Lume.once(function(ship) 
        ship.speed             = ship.prev_speed 
        ship.weapon.proj_speed = ship.prev_proj_speed
        end,ship),10)
end

local function getPowerUpFunc(powerup_type)
    if powerup_type == 1 then
        return restoreHealth
    elseif powerup_type == 2 then
        return tempHealth
    elseif powerup_type == 3 then
        return multiShot
    elseif powerup_type == 4 then
        return increaseSpeed
    elseif powerup_type == 5 then
        return mouseTarget
    end
end

local function getPowerUpType(rand)
    local n = rand(1,16)
    if n < 2 then
        return 2
    elseif n < 5 then
        return 5
    elseif n < 8 then
        return 3 
    elseif n < 12 then
        return 4
    else
        return 1
    end

end

local function getPowerUpIcon(powerup_type)
    return love.graphics.newImage("assets/img/power_ups/" .. POWERUP_ICONS[powerup_type])
end

function POWERUP:new(rand)
    local powerup_type = getPowerUpType(rand)
    local icon         = getPowerUpIcon(powerup_type)
    local x,y          = makeXY(POWERUP_LIST,rand)
    local o            = setmetatable(OBJECT:new(x,y,0,icon),POWERUP)
    o.func             = getPowerUpFunc(powerup_type)--POWERUP_FUNCS[1]--powerup_type]
    o.sound            = love.audio.newSource("/assets/sounds/power_ups/pickup_powerup.ogg","static")
    return o
end

