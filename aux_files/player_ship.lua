--File contains functions related to player ship objects

local Ship = require("aux_files.ship")
local powerup = require("aux_files.powerup")

PLAYER_SHIP = 
    {
        target_mouse = nil, target_angle = nil,target_x = nil, target_y = nil,prev_health = nil, 
        prev_weapon = nil,prev_speed = nil,prev_time_shots = nil,sound = nil
    }
PLAYER_SHIP.__index = PLAYER_SHIP
setmetatable(PLAYER_SHIP,SHIP)


function PLAYER_SHIP:printPlayer()
    self:printFunc()
    if MOVE == true then
        self:printThruster()
    end
end

--get the x and y of mouse pointer
function PLAYER_SHIP:playerTargetMouse()
    self.target_x = love.mouse.getX() + self.x - HALF_W
    self.target_y = love.mouse.getY() + self.y - HALF_H
    self.target_angle = self:getNewTargetAngle()
end

function PLAYER_SHIP:shootFunc()
    if self.target_mouse == false then
        self.target_angle = self.move_angle
    else
        self:playerTargetMouse()
    end
    self.weapon.target_angle = self.target_angle
    self.weapon:shootFunc(self,PLAYER_PROJ)
end

function PLAYER_SHIP:updatePlayer(dt)
    local j = iterateList(ENEMY_PROJ,checkForCollision,self)
    if j ~= -1 then
        table.remove(ENEMY_PROJ,j)
        self:changeHealth(-1)
    end

    local p = iterateList(POWERUP_LIST,checkForCollision,self)
    if p ~= -1 then
        POWERUP_LIST[p].sound:play()
        POWERUP_LIST[p].func(self)
        table.remove(POWERUP_LIST,p)
    end

    if FACE_MOUSE == true then  --if player has toggled FACE_MOUSE on
        --player ship should turn to face mouse pointer
        self:playerTargetMouse()
        self.move_angle  = self.target_angle
    end
    if MOVE == true then
        local x,y  = self:getNewXY(dt)
        self:changeXY(x,y)
        self.sound:play()
    else
        self.sound:stop()
    end
end

function PLAYER_SHIP:makePlayer()
    local rand           = math.random
    local icon           = love.graphics.newImage("assets/img/ships/player.png")
    local o              = setmetatable(SHIP:new(rand,icon),PLAYER_SHIP)
    o.shoot_func         = shootSingle
    o.time_between_shots = 0.5
    o.speed              = rand(175,MAX_SPEED)
    o.target_mouse       = false
    o.thruster           = THRUSTER:new(o.x,o.y,o.move_angle,rand) 
    o.target_angle       = o.move_angle
    o.health             = 6
    o.max_health         = o.health
    o.weapon             = SINGLE_SHOT:new(rand,o.speed)
    o.prev_speed         = o.speed
    o.prev_weapon        = o.weapon
    o.prev_proj_speed    = o.weapon.proj_speed
    o.sound              = love.audio.newSource("/assets/sounds/thruster/rocket_thruster.mp3","static")
    o.sound:setVolume(0.7)
    o.weapon.proj_speed  = o.speed * (1.75 + rand() * 0.25) 
    o.weapon.time_between_shots = 0.4 + rand() * 0.2 
    o.prev_time_shots           = o.weapon.time_between_shots
    return o
end

