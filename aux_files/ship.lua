--File conatins functions for creating and manipulating ship objects

local Obj   = require("aux_files.object")

SHIP = {target_x = nil, target_y = nil,movable = nil,speed = nil,health = nil, max_health = nil, shoot_func = nil,score = nil,thruster = nil,missle = nil}
SHIP.__index = SHIP
setmetatable(SHIP,OBJECT)

THRUSTER = {}
THRUSTER.__index = THRUSTER
setmetatable(THRUSTER,OBJECT)

local TYPE_NAMES = {"Fighter","UFO","Rocket","Satellite","Space_station","Comet","Solitary_Ship"}


--if the fighter can chase the player hen do so if player is visible, otherwise just move straight
function SHIP:canChasePlayer()
    if self.isPlayerVisible() == true then
        self.lookAtPlayer()
        self.moveStraightLine()
    else
        self.moveStraightLine()
    end
end

--look at a random spot near player position
function SHIP:lookAtPlayer()
    if self.isPlayerVisible() == true then
        self.target_x = math.random(PLAYER.x - 5, PLAYER.x + 5)
        self.target_y = math.random(PLAYER.y - 5, PLAYER.x + 5)
        self.getnewAngle()
    end
end

--change a ships health
function SHIP:changeHealth(h)
    self.health = self.health + h
    if self.health > self.max_health then
        self.health = self.max_health
    end
end

--cahnge angle of ship based on targeting location
function SHIP:getNewAngle()
    self.angle = math.atan2(self.target_y - self.y,self.target_x - self.x)
end

--get new random angle between 90 and 270 degrees
function SHIP:getRandomAngle()
    local angle = self.angle - 1.57079 * math.random() * 3.14159
end

local function updateShip(i)
    if SHIP_LIST[i].moveable == true then
        SHIP_LIST[i].move_func(SHIP_LIST[i])
    end
    local j = iterateList(SHIP_LIST,checkForCollision,SHIP_LIST[i])
    if j ~= -1 then
        table.remove(SHIP_LIST,i)
        table.remove(SIP_LIST,j)
        return false
    end
    if SHIP_LIST[i].shoot_func ~= nil then
        SHIP_LIST[i].shoot_func(SHIP_LIST[i])
    end
    return false
end

function updateAllShips()
    iterateList(SHIP_LIST,updateShip,nil)
end

local function getShipType()
    if math.random(1,3) < 3 then
        return TYPE_NAMES[1]
    else
        return TYPE_NAMES[math.random(2,#TYPE_NAMES)]
    end
end

local function getIcon(ship_type)
    local icon
    if ship_type == TYPE_NAMES[1] then
        icon = "/assets/img/ships/fighter_" .. math.random(1,2) .. ".png"
    elseif ship_type == TYPE_NAMES[2] then
        icon = "/assets/img/ships/ufo."
    elseif ship_type == TYPE_NAMES[3] then
        icon = "/assets/img/ships/rocket."
    elseif ship_type == TYPE_NAMES[4] then
        icon = "/assets/img/ships/satellite_" .. math.random(1,5) .. ".png"
    elseif ship_type == TYPE_NAME[5] then
        icon = "/assets/img/ships/space_station_" .. math.random(1,3) .. ".png"
    elseif ship_type  == TYPE_NAMES[6] then
        icon = "/assets/img/ships/comet.png"
    elseif ship_type == TYPE_NAMES[7] then
        icon = "/assets/img/ships/stationary_ship.png"
    end
      return love.graphics.newImage(icon)
end

local function getSound()
    local n = math.random(1,3)
    return love.audio.newSource("","static")
end

local function getSpeed(moveable)
    return math.random(100,250)

end

local function getChase(ship_type)
    if ship_type == TYPE_NAMES[1] then
        return math.random(1,3) < 3 and true or false
    end
    return false
end

local function getMoveable(ship_type)
    if ship_type == TYPE_NAMES[5] or ship_type == TYPE_NAMES[7] then
        return false
    end
    return true
end

local function makeXY()
    local rand    = math.random
    local params  = {x = nil, y = nil}
    local func    = checkIfOVerlap
    local iterate = iterateList
    repeat
        params.x = rand(1,GAME_W)
        params.y = rand(1,GAME_H)
    until(iterate(SHIP_LIST,func,params) == -1)
    return params.x,params.y
end

local function getThrusterIcon()
    return love.graphics.newImage("/assets/img/effects/thrust_" .. math.random(1,3) .. ".png")
end

function THRUSTER:new(x,y,angle)
    local icon = getThrusterIcon()
    local o    = setmetatable(OBJECT:new(x,y,angle,icon),THRUSTER)
    return o
end

local function makeThruster(x,y,angle,ship_type)
    if ship_type == TYPE_NAMES[1] or ship_type == TYPE_NAMES[3] then
        return THRUSTER:new(x,y,angle)
    end
    return nil
end

local function getAngle(ship_type)
    if ship_type == TYPE_NAMES[2] == true then
        return 0
    end
    return -3.14159 + math.random() * 6.28318530718
end

local function getMissleOrLaser()
    local n = math.random(1,3)
    if n < 3 then
        return false
    end
    return true
end

local function getLaserColor(missle)
    if missle == false then
        return math.random(1,3)
    end
    return nil
end

function SHIP:new()
    local ship_type  = getShipType()
    local icon       = love.graphics.newImage("/assets/img/ships/player.png")--getIcon(ship_type)
    local moveable   = getMoveable(ship_type)
   -- local chase      = getChase(ship_type)
    local x,y        = makeXY()
    local o          = setmetatable(OBJECT:new(x,y,angle,icon),SHIP)
    --o.sound          = getSound(moveable) 
    o.speed          = getSpeed(moveable)
   -- o.shoot_func     = getShootFunc(moveable,chase)
    o.angle          = getAngle()
    o.thruster       = makeThruster(x,y,o.angle,ship_type)
  --  o.missle         = getMissleOrLaser()
    return o
end

function makeEnemyShips()
    local n = math.random(10,30)
    for i=1,n,1 do
        table.insert(SHIP_LIST,SHIP:new())
    end
end

