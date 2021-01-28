--File conatins functions for creating and manipulating ship objects

local Thrust = require("aux_files.thruster")
local Obj    = require("aux_files.object")

SHIP = { x = nil, y = nil,speed = nil,health = nil, max_health = nil,thruster = nil}

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
function SHIP:getNewRandomMoveAngle()
    return self.move_angle - 1.57079 * math.random() * 3.14159
end

--change angle of ship based on targeting location
function SHIP:getNewTargetAngle()
    return math.atan2(self.target_y - self.y,self.target_x - self.x)
end

function SHIP:moveStraight(dt)
    if self:moveStraightLine(dt) == false then
        self.move_angle = self:getNewRandomMoveAngle()
        return false
    end
    return true
end

function SHIP:moveFunc(dt) 
    self:moveStraight(dt)
end

function SHIP:update(list,i,dt)
    local j = iterateList(PLAYER_PROJ,checkForCollision,self)
    if j ~= -1 then
        table.remove(PLAYER_PROJ,j)
        self:changeHealth(-1)
    end
    if self.health <= 0  then
        PLAYER_SCORE = PLAYER_SCORE + self.score
        table.remove(list,i)
    else
        self:moveFunc(dt) 
        self:shootFunc(ENEMY_PROJ)
    end
end

function getSpeed(rand)
    return rand(125,MAX_SPEED)
end

function SHIP:new(rand,icon)
    local x,y            = makeXY(SHIP_LIST,rand)
    local angle          = getAngle(rand)
    local o              = setmetatable(OBJECT:new(x,y,angle,icon),SHIP)
    o.health             = 1
    o.max_health         = o.health
    o.time_since_shot    = love.timer.getTime()
    o.speed              = getSpeed(rand)
    return o
end

