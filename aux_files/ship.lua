--File conatins functions for creating and manipulating ship objects

local Obj   = require("aux_files.object")
local Proj  = require("aux_files.projectile")

SHIP = {
        target_x = nil, target_y = nil,moveable = nil,speed = nil,health = nil, 
        max_health = nil, shoot_func = nil,score = nil,thruster = nil,missle = nil,
        chase = nil,time_since_seen = nil,time_since_shot = nil, time_between_shots = nil
    }

SHIP.__index = SHIP
setmetatable(SHIP,OBJECT)

THRUSTER = {}
THRUSTER.__index = THRUSTER
setmetatable(THRUSTER,OBJECT)

local TYPE_NAMES = {"Fighter","UFO","Rocket","Satellite","Space_station","Solitary_Ship"}


function SHIP:shootSingle(t_off,dt)
   local proj = PROJECTILE:new(self.x,self.y,self.move_angle,t_off,self.missle,self.color,self.speed) 
   table.insert(PROJ_LIST,proj)
end

function SHIP:shootMulti(dt)
    local add   = table.insert()
    local angle = self.print_angle
    for i=1,12,1 do
        angle = angle - 0.5235988
        local proj = PROJECTILE:new(self.x,self.y,angle,false,self.missle,self.color,self.speed) 
    end

end

--if the fighter can chase the player hen do so if player is visible, otherwise just move straight
function chasePlayer(ship,dt)
    if ship:isPlayerVisible() == true and love.timer.getTime() - ship.time_since_seen > 1.2 then
        lookAtPlayer(ship)
        moveStraightLine(ship,dt)
        ship.time_since = love.timer.getTime()
    else
        moveStraightLine(ship,dt)
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


--look at a random spot near player position
function lookAtPlayer(ship)
    if ship:isPlayerVisible() == true then
        ship.target_x = PLAYER.x
        ship.target_y = PLAYER.y
        ship:getNewAngle()
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
    if self.ship_type ~= "UFO" then
        self.print_angle = self.move_angle
    end
end

--get new random angle between 90 and 270 degrees
function SHIP:getRandomAngle()
    self.move_angle = self.move_angle - 1.57079 * math.random() * 3.14159
    if self.ship_type ~= "UFO" then
        self.print_angle = self.move_angle
    end
end

function SHIP:printPlayer()
    self:printObj()
    if MOVE == true then
        self:printThruster()
    end
end

function printShip(list,i,_)
    list[i]:printObj()
    list[i]:printThruster()
end


function updateShip(list,i,dt)
    if list[i].health <= 0 then
        table.remove(list,i)
    else
        if list[i]:moveObject(dt) == false then
            list[i]:getRandomAngle()
        end
       --[[ local j = iterateList(list,checkForCollision,list[i])
        if j ~= -1 then
            table.remove(list,i)
            table.remove(list,j)
            return false
        end
        if list[i].shoot_func ~= nil then
            list[i].shoot_func(list[i])
        end
        --]]
    end
    return false
end

function SHIP:updatePlayer(dt)
    playerTargetMouse()
    self:getNewAngle()
    if MOVE == true then
        local x,y  = self:getNewXY(dt)
        self:changeXY(x,y)
    end
end

local function getShipType(rand)
    if rand(1,3) < 3 then
        return TYPE_NAMES[1]
    else
        return TYPE_NAMES[rand(2,#TYPE_NAMES)]
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

local function getSpeed(rand)
    return rand(50,PLAYER.speed)

end

local function getChase(rand,ship_type)
    if ship_type == TYPE_NAMES[1] then
        return rand(1,3) < 3 and true or false
    end
    return false
end

local function getMoveable(ship_type)
    if ship_type == TYPE_NAMES[5] or ship_type == TYPE_NAMES[6] then
        return false
    end
    return true
end


local function getThrusterIcon(rand)
    return love.graphics.newImage("/assets/img/thrusters/thrust_" .. rand(1,5) .. ".png")
end


function THRUSTER:new(x,y,angle,rand)
    local icon = getThrusterIcon(rand)
    local o    = setmetatable(OBJECT:new(x,y,angle,icon),THRUSTER)
    return o
end

local function makeThruster(x,y,angle,rand)
    return THRUSTER:new(x,y,angle,rand)
end


local function getMissleOrLaser(rand)
    local n = random(1,3)
    if n < 3 then
        return false
    end
    return true
end

local function getLaserColor(rand,missle)
    if missle == false then
        return rand(1,3)
    end
    return nil
end

local function getHealth(ship_type)
    return 3
end


local function getThruster(rand,ship)
    if ship.moveable == false or ship.ship_type == TYPE_NAMES[2] or ship.ship_type == TYPE_NAMES[4] then
        return nil
    end 
        return makeThruster(ship.x,ship.y,ship.move_angle,rand)
end

local function getMoveFunc(ship)
    if ship.moveable == false then
        return lookAtPlayer
    elseif ship.chase == false then
        return moveStraightLine
    else
        return chasePlayer
    end
end

function SHIP:new(rand)
    local ship_type     = getShipType(rand)
    local icon          = getIcon(rand,ship_type)
    local x,y           = makeXY(SHIP_LIST,rand)
    local o             = setmetatable(OBJECT:new(x,y,angle,icon),SHIP)
    o.chase             = getChase(rand,ship_type)
    o.ship_type         = ship_type
    o.moveable          = getMoveable(ship_type)
    --o.sound           = getSound(o.moveable) 
    o.speed             = getSpeed(rand,o.moveable)
   -- o.shoot_func      = getShootFunc(o.moveable,chase)
    o.move_angle        = getAngle(rand)
    o.print_angle       = o.ship_type ~= "UFO" and o.move_angle or 0
    o.thruster          = getThruster(rand,o) 
    o.health            = getHealth(ship_type)
    o.max_health        = o.health
    o.move_func         = getMoveFunc(o)
    o.time_since_seen   = love.timer.getTime()
    o.time_since_shot   = o.time_since_seen
    o.time_between_shots = 0.5 + rand() * 1.5
  --  o.missle          = getMissleOrLaser(rand)
    return o
end

function SHIP:makePlayer()
    local rand       = math.random
    local ship_type  = "Player"
    local icon       = getIcon(rand,ship_type)
    local moveable   = true 
    local x,y        = makeXY(nil,rand)
    local o          = setmetatable(OBJECT:new(x,y,angle,icon),SHIP)
    --o.sound          = getSound(moveable) 
    o.speed          = rand(120,220)
   -- o.shoot_func     = getShootFunc(moveable,chase)
    o.angle          = getAngle(rand,ship_type)
    o.thruster       = makeThruster(x,y,o.angle,rand)
  --  o.missle         = getMissleOrLaser()
    return o
end

function makeEnemyShips()
    local rand = math.random
    local add  = table.insert
    local n = math.random(20,60)
    for i=1,n,1 do
        add(SHIP_LIST,SHIP:new(rand))
    end
end

