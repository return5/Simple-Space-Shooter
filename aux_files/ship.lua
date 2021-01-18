--File conatins functions for creating and manipulating ship objects

local Obj   = require("aux_files.object")
local Proj  = require("aux_files.projectile")
local Thrust = require("aux_files.thruster")

SHIP = { 
            x = nil, y = nil,target_x = nil, target_y = nil,speed = nil,health = nil, max_health = nil,thruster = nil,
            missile = nil,time_since_shot = nil, time_between_shots = nil,proj_speed = nil,shoot_func = nil,t_off = nil,
            proj_icon = nil
        }

SHIP.__index = SHIP
setmetatable(SHIP,OBJECT)

TYPE_NAMES  = {"Fighter","UFO","Rocket","Satellite","Space_station","Solitary_Ship"}
local PROJ_COLORS = {"blue","red","green","yellow"}


function shootSingle(list,ship)
    if love.timer.getTime() - ship.time_since_shot > ship.time_between_shots then
        table.insert(list,PROJECTILE:new(ship.x,ship.y,ship.move_angle,ship.t_off,ship.missile,ship.proj_icon,ship.proj_speed))
        ship.time_since_shot = love.timer.getTime()
    end
end

function shootCircle(list,ship)
    if love.timer.getTime() - ship.time_since_shot > ship.time_between_shots then
        local add   = table.insert
        local angle = ship.print_angle
        for i=1,12,1 do
            angle = angle - 0.5235988
            add(list,PROJECTILE:new(ship.x,ship.y,angle,ship.t_off,ship.missile,ship.proj_icon,ship.proj_speed))
        end
        ship.time_since_shot = love.timer.getTime()
    end
end

function SHIP:printThruster()
    if self.thruster ~= nil then
        self.thruster.x           = self.x
        self.thruster.y           = self.y
        self.thruster.print_angle = self.move_angle
        self.thruster:printObj()
    end
end

--change a ships health
function SHIP:changeHealth(h)
    self.health = self.health + h
    if self.health > self.max_health then
        self.health = self.max_health
    end
end

--change angle of ship based on targeting location
function SHIP:getNewAngle()
    self.move_angle = math.atan2(self.target_y - self.y,self.target_x - self.x)
    if self.ship_type ~= TYPE_NAMES[2] then
        self.print_angle = self.move_angle
    end
end

local function getIcon(rand,ship_type)
    local icon
    if ship_type == TYPE_NAMES[1] then
        icon = "/assets/img/ships/fighter_" .. rand(1,2) .. ".png"
    elseif ship_type == TYPE_NAMES[2] then
        icon = "/assets/img/ships/ship_icon_ufo.png"
    elseif ship_type == TYPE_NAMES[3] then
        icon = "/assets/img/ships/rocket.png"
    elseif ship_type == TYPE_NAMES[4] then
        icon = "/assets/img/ships/satellite_" .. rand(1,5) .. ".png"
    elseif ship_type == TYPE_NAMES[5] then
        icon = "/assets/img/ships/space_station_" .. rand(1,3) .. ".png"
    elseif ship_type == TYPE_NAMES[6] then
        icon = "/assets/img/ships/rocket.png"
    elseif ship_type == "Player" then
        icon = "/assets/img/ships/player.png"
    end
      return love.graphics.newImage(icon)
end

local function getSound(rand)
    local n = rand(1,3)
    return love.audio.newSource("","static")
end

function getSpeed(rand,ship_type,chase)
    if ship_type == "Player" then
        return rand(150,220)
    elseif ship_type == TYPE_NAMES[1] and chase == true then
        return rand(20,PLAYER.speed - 125)
    end
    return rand(125,PLAYER.speed)
end

local function getMoveable(ship_type)
    if ship_type == TYPE_NAMES[5] or ship_type == TYPE_NAMES[6] then
        return false
    end
    return true
end

local function getProjectileIcon(rand,missile)
    local color = PROJ_COLORS[rand(1,#PROJ_COLORS)]
    local icon 
    if missile == true then
        icon = "/assets/img/weapons/missile_" .. color .. ".png"
    else
        icon = "/assers/ing/weapons/laser_" .. color .. ".png"
    end
    return love.graphics.newImage(icon)
end

local function getMissileOrLaser(rand,ship_type)
    if ship_type == TYPE_NAMES[2] then
        return false
    end
    return random(1,3) < 3
end

local function getHealth(ship_type)
    if ship_type == "Player" then
        return 5
    elseif ship_type == TYPE_NAMES[5] then
        return 3
    end
    return 1
end

local function getThruster(rand,ship)
    if ship.moveable == false or ship.ship_type == TYPE_NAMES[2] or ship.ship_type == TYPE_NAMES[4] then
        return nil
    end 
        return THRUSTER:new(ship.x,ship.y,ship.move_angle,rand)
end

local function getTOff(rand,ship_type)
    if ship_type == "Player" then
        return false
    end
    return rand(0,5) < 3 
end


function SHIP:new(rand,ship_type,chase)
    local x,y            = makeXY(SHIP_LIST,rand)
    local angle          = getAngle(rand,ship_type)
    local icon           = getIcon(rand,ship_type)
    local o              = setmetatable(OBJECT:new(x,y,angle,icon),SHIP)
    o.ship_type          = ship_type
    o.moveable           = getMoveable(ship_type)
    o.move_angle         = getAngle(rand)
    o.print_angle        = o.ship_type ~= TYPE_NAMES[2] and o.move_angle or 0
    o.thruster           = getThruster(rand,o) 
    o.health             = getHealth(ship_type)
    o.max_health         = o.health
    o.time_since_shot    = love.timer.getTime()
    o.missile            = true -- getMissleOrLaser(rand)
    o.proj_icon          = getProjectileIcon(rand,o.missile)
    o.speed              = getSpeed(rand,ship_type,chase)
    o.t_off              = getTOff(rand,ship_type)
    return o
end

