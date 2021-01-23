--File conatins functions for creating and manipulating ship objects

local Thrust = require("aux_files.thruster")

SHIP = { x = nil, y = nil,target_x = nil, target_y = nil,speed = nil,health = nil, max_health = nil,thruster = nil}

SHIP.__index = SHIP
setmetatable(SHIP,OBJECT)

function SHIP:printThruster()
    if self.thruster ~= nil then
        self.thruster.x           = self.x
        self.thruster.y           = self.y
        self.thruster.move_angle  = self.move_angle
        self.thruster:printFunc()
    end
end

function SHIP:printFunc()
    OBJECT.printFunc(self)
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
        self:moveFunc(dt) 
        self:shootFunc(ENEMY_PROJ)
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
    o.health             = getHealth()
    o.max_health         = o.health
    o.time_since_shot    = love.timer.getTime()
    o.speed              = getSpeed(rand)
    return o
end

