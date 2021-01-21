--File conatins functions for creating and manipulating ship objects

local Proj   = require("aux_files.projectile")
local Thrust = require("aux_files.thruster")

SHIP = { 
            x = nil, y = nil,target_x = nil, target_y = nil,speed = nil,health = nil, max_health = nil,thruster = nil,
            missile = nil,time_since_shot = nil, time_between_shots = nil,proj_speed = nil,shoot_func = nil,t_off = nil,
            proj_icon = nil,move_func = nil,print_func = nil
        }

SHIP.__index = SHIP
setmetatable(SHIP,OBJECT)

local PROJ_COLORS = {"blue","red","green","yellow"}


function SHIP:shootSingle(list)
    if love.timer.getTime() - self.time_since_shot > self.time_between_shots then
        table.insert(list,PROJECTILE:new(self.x,self.y,self.target_angle,self.t_off,self.missile,self.proj_icon,self.proj_speed))
        self.time_since_shot = love.timer.getTime()
    end
end

function SHIP:shootCircle(list)
    if love.timer.getTime() - self.time_since_shot > self.time_between_shots then
        local add   = table.insert
        local angle = self.target_angle
        for i=1,12,1 do
            angle = angle - 0.5235988
            add(list,PROJECTILE:new(self.x,self.y,angle,self.t_off,self.missile,self.proj_icon,self.proj_speed))
        end
        self.time_since_shot = love.timer.getTime()
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

function SHIP:checkHealth()
    if self.health > self.max_health then
        self.health = self.max_health
    end
end

--change a ships health
function SHIP:changeHealth(h)
    self.health = self.health + h
end
--
--get new random angle between 90 and 270 degrees
function SHIP:getRandomMoveAngle()
    return self.move_angle - 1.57079 * math.random() * 3.14159
end


--change angle of ship based on targeting location
function SHIP:getNewTargetAngle()
    return math.atan2(self.target_y - self.y,self.target_x - self.x)
end

function SHIP:getNewRandomMoveAngle()
    return self.move_angle
end

function SHIP:moveStraight(dt)
    if self:moveStraightLine(dt) == false then
        self.move_angle = self:getNewRandomMoveAngle()
    end
end

function SHIP:update(list,i,dt)
    local j = iterateList(PLAYER_PROJ,checkforCollision,self)
    if j ~= -1 then
        table.remove(PLAYER_PROJ,j)
        self:changeHEalth(-1)
    end
    if self.health <= 0  then
        table.remove(list,i)
    else
        self:move_func(dt) 
        self:shoot_func(ENEMY_PROJ)
    end
end

local function getSound(rand,missile)
    if missile == true then
        return love.audio.newSource("assets/sounds/weapons/missile_sound_" .. rand(1,3) ..".oog","static")
    end
    return love.audio.newSource("asstes/sounds/weapons/laser_sound_" .. rand(1,5) .. ".oog","static")
end

function getSpeed(rand)
    return rand(125,MAX_SPEED)
end

local function getProjectileIcon(rand,missile)
    local color = PROJ_COLORS[rand(1,#PROJ_COLORS)]
    local icon 
    if missile == true then
        icon = "/assets/img/weapons/missile_" .. color .. ".png"
    else
        icon = "/assets/img/weapons/laser_" .. color .. ".png"
    end
    return love.graphics.newImage(icon)
end

local function getMissileOrLaser(rand)
    return rand(1,3) < 3
end

local function getHealth()
    return 1
end

local function getTOff(rand)
    return rand(0,5) < 3 
end


function SHIP:new(rand,icon)
    local x,y            = makeXY(SHIP_LIST,rand)
    local angle          = getAngle(rand)
    local o              = setmetatable(OBJECT:new(x,y,angle,icon),SHIP)
    o.thruster           = THRUSTER:new(x,y,move_angle,rand) 
    o.health             = getHealth()
    o.max_health         = o.health
    o.time_since_shot    = love.timer.getTime()
    o.missile            = getMissileOrLaser(rand)
    o.proj_icon          = getProjectileIcon(rand,o.missile)
    o.speed              = getSpeed(rand)
    o.t_off              = getTOff(rand)
    return o
end

