--File conatins functions for creating and manipulating ship objects

local Obj   = require("aux_files.object")
local Proj  = require("aux_files.projectile")

SHIP = { 
            x = nil, y = nil,target_x = nil, target_y = nil,speed = nil,health = nil, max_health = nil,thruster = nil,
            missile = nil,time_since_shot = nil, time_between_shots = nil,proj_speed = nil,shoot_func = nil,t_off = nil,
            proj_icon = nil
        }

SHIP.__index = SHIP
setmetatable(SHIP,OBJECT)

PLAYER_SHIP = {}
PLAYER_SHIP.__index = PLAYER_SHIP
setmetatable(PLAYER_SHIP,SHIP)


ENEMY_SHIP = {moveable = nil, score = nil,chase = nil,time_since_seen = nil,move_func = nil}
ENEMY_SHIP.__index = ENEMY_SHIP
setmetatable(ENEMY_SHIP,SHIP)


THRUSTER = {}
THRUSTER.__index = THRUSTER
setmetatable(THRUSTER,OBJECT)

local TYPE_NAMES  = {"Fighter","UFO","Rocket","Satellite","Space_station","Solitary_Ship"}
local PROJ_COLORS = {"blue","red","green"}


function shootSingle(ship)
   table.insert(PROJ_LIST,PROJECTILE:new(ship.x,ship.y,ship.move_angle,t_off,ship.missile,ship.proj_icon,ship.proj_speed))
end

function shootMulti(ship)
    local add   = table.insert()
    local angle = ship.print_angle
    for i=1,12,1 do
        angle = angle - 0.5235988
        add(PROJ_LIST,PROJECTILE:new(ship.x,ship.y,angle,ship.t_off,ship.missile,ship.proj_icon,ship.proj_speed))
    end
end

--if the fighter can chase the player hen do so if player is visible, otherwise just move straight
function chasePlayer(ship,dt)
    if ship:isPlayerVisible() == true then
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
    if ship:isPlayerVisible() == true and love.timer.getTime() - ship.time_since_seen > 1.2 then
        ship.target_x = math.random(PLAYER.x - 5, PLAYER.x + 5)
        ship.target_y = math.random(PLAYER.y - 5,PLAYER.y + 5)
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
    if self.ship_type ~= TYPE_NAMES[2] then
        self.print_angle = self.move_angle
    end
end

--get new random angle between 90 and 270 degrees
function ENEMY_SHIP:getRandomAngle()
    self.move_angle = self.move_angle - 1.57079 * math.random() * 3.14159
    if self.ship_type ~= TYPE_NAMES[2] then
        self.print_angle = self.move_angle
    end
end

function PLAYER_SHIP:printPlayer()
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

function PLAYER_SHIP:updatePlayer(dt)
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

local function getSpeed(rand,ship)
    if ship.ship_type == "Player" then
        return rand(150,220)
    elseif ship.ship_type == TYPE_NAMES[1] and ship.chase == true then
        return rand(50,PLAYER.speed - 75)
    end
    return rand(125,PLAYER.speed)
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

local function getMissleOrLaser(rand)
    local n = random(1,3)
    if n < 3 then
        return false
    end
    return true
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


local function getShootFunc(rand,ship_type)
   if ship_type == TYPE_NAMES[2] then
       return ufoShoot
   elseif ship_type == TYPE_NAMES[4] then
       return nil
   elseif ship_type == "Player" then
       return shootSingle
   else
       return rand(0,5) < 4 and singleShot or multiShot
    end 
end

local function getScore(ship)
    if ship.ship_type == TYPE_NAMES[1] then
        if ship.chase == true then
            return 15
        else
            return 5
        end
    elseif ship.ship_type == TYPE_NAMES[2] then
        return 20
    elseif ship.ship_type == TYPE_NAMES[3] then
        return 5
    elseif ship.ship_type == TYPE_NAMES[4] then
        return 10
    elseif ship.ship_type == TYPE_NAMES[5] then
        return 15
    elseif ship.ship_type == TYPE_NAMES[6] then
        return 10
    end
end

local function getProjSpeed(rand,speed)
    return speed + (.5 + rand() * 1.5) * speed

end

function SHIP:new(rand,ship_type,speed)
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
    o.shoot_func         = getShootFunc(rand,ship_type)
    o.time_since_shot    = love.timer.getTime()
    o.time_between_shots = 0.5 + rand() * 1.5
    o.missile            = true -- getMissleOrLaser(rand)
    o.proj_icon          = getProjectileIcon(rand,o.missile)
    return o
end

function ENEMY_SHIP:new(rand)
    local ship_type     = getShipType(rand)
    local o             = setmetatable(SHIP:new(rand,ship_type),ENEMY_SHIP)
    o.chase             = getChase(rand,ship_type)
    o.time_since_seen   = o.time_since_shot
    o.score             = getScore(o)
    o.move_func         = getMoveFunc(o)
    o.speed             = getSpeed(rand,o)
    o.proj_speed        = getProjSpeed(rand,o.speed)
    return o
end

function PLAYER_SHIP:makePlayer()
    local rand       = math.random
    local ship_type  = "Player"
    local o          = setmetatable(SHIP:new(rand,ship_type),PLAYER_SHIP)
    o.speed          = getSpeed(rand,o)
    o.proj_speed     = getProjSpeed(rand,o.speed)
    --o.sound          = getSound(moveable) 
   -- o.shoot_func     = getShootFunc(moveable,chase)
    return o
end

function makeEnemyShips()
    local rand = math.random
    local add  = table.insert
    local n = math.random(20,60)
    for i=1,n,1 do
        add(SHIP_LIST,ENEMY_SHIP:new(rand))
    end
end

