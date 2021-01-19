--File contains functions for delaing with Enemy ship objects

local Ship = require("aux_files.ship")


ENEMY_SHIP = {moveable = nil, score = nil,chase = nil,time_since_seen = nil,move_func = nil,shoot_if_player_notvis = nil}
ENEMY_SHIP.__index = ENEMY_SHIP
setmetatable(ENEMY_SHIP,SHIP)


function ENEMY_SHIP:shootFunc()
    if self.shoot_if_player_notvis == true or self:isPlayerVisible() == true then
        self.shoot_func(ENEMY_PROJ,self)
    end
end

function printEnemyShip(list,i,_)
    list[i]:printObj()
    list[i]:printThruster()
end

function updateEnemyShip(list,i,dt)
    local j = iterateList(PLAYER_PROJ,checkForCollision,list[i])
    if j ~= -1 then
        table.remove(PLAYER_PROJ,j)
        list[i]:changeHealth(-1)
    end
    if list[i].health <= 0 then
        table.remove(list,i)
    else
        if list[i]:moveObject(dt) == false then
            list[i]:getRandomAngle()
            if list[i].ship_type ~= TYPE_NAMES[2] then
                list[i].target_angle = list[i].move_angle
            end
        end
        if list[i].shoot_func ~= nil then
            list[i]:shootFunc()
        end
    end
    return false
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

--look at a random spot near player position
function ENEMY_SHIP:targetPlayer()
    if self:isPlayerVisible() == true and love.timer.getTime() - self.time_since_seen > 2 then
        self.target_x = math.random(PLAYER.x - 10, PLAYER.x + 10)
        self.target_y = math.random(PLAYER.y - 10,PLAYER.y + 10)
        self:getNewTargetAngle()
    end
end


function lookAtPlayer(ship)
    ship:targetPlayer()
end

local function getShootFunc(rand,ship_type)
    if ship_type == TYPE_NAMES[4] or ship_type == TYPE_NAMES[2]then
       return nil
   else
       return rand(0,5) < 4 and shootSingle or shootCircle
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

--get new random angle between 90 and 270 degrees
function ENEMY_SHIP:getRandomAngle()
    self.move_angle = self.move_angle - 1.57079 * math.random() * 3.14159
    if self.ship_type ~= TYPE_NAMES[2] then
        self.print_angle  = self.move_angle
        self.target_ablge = self.move_angle
    end
end

--if the fighter can chase the player then do so if player is visible, otherwise just move straight
function chasePlayer(ship,dt)
    if ship:isPlayerVisible() == true then
        lookAtPlayer(ship)
        ship.move_angle  = ship.target_angle
        ship.print_angle = ship.target_angle
        moveStraightLine(ship,dt)
        ship.time_since = love.timer.getTime()
    else
        moveStraightLine(ship,dt)
    end
end

local function getChase(rand,ship_type)
    if ship_type == TYPE_NAMES[1] then
        return rand(1,3) < 3 
    end
    return false
end

function getShipType(rand)
    if rand(1,3) < 3 then
        return TYPE_NAMES[1]
    else
        return TYPE_NAMES[rand(2,#TYPE_NAMES)]
    end
end

local function getProjSpeed(rand,ship_speed)
    local speed =  (.5 + rand() * .25) * PLAYER.speed
    if speed < ship_speed then
        speed = ship_speed * 1.5
    end
    return speed
end

function ENEMY_SHIP:new(rand,ship_type)
    local chase          = getChase(rand,ship_type)
    local o              = setmetatable(SHIP:new(rand,ship_type,chase),ENEMY_SHIP)
    o.chase              = chase
    o.time_between_shots = 0.75 + rand() * 1.5
    o.time_since_seen    = o.time_since_shot
    o.score              = getScore(o)
    o.move_func          = getMoveFunc(o)
    o.shoot_func         = getShootFunc(rand,ship_type)
    o.proj_speed         = getProjSpeed(rand,o.speed)
    o.shoot_if_player_notvis = rand(1,3) < 3 
    return o
end


