--File contains functions related to player ship objects

local Ship = require("aux_files.ship")

PLAYER_SHIP = {target_mouse = nil}
PLAYER_SHIP.__index = PLAYER_SHIP
setmetatable(PLAYER_SHIP,SHIP)


function PLAYER_SHIP:printPlayer()
    self.print_angle = self.move_angle
    self:printObj()
    if MOVE == true then
        self:printThruster()
    end
end

--get the x and y of mouse pointer
function PLAYER_SHIP:playerTargetMouse()
    self.target_x = love.mouse.getX() + self.x - HALF_W
    self.target_y = love.mouse.getY() + self.y - HALF_H
    self:getNewTargetAngle()
end

function PLAYER_SHIP:shootFunc()
    if self.target_mouse == false then
        self.target_angle = self.move_angle
    else
        self:playerTargetMouse()
    end
    self.shoot_func(PLAYER_PROJ,self)
end

function PLAYER_SHIP:updatePlayer(dt)
    local j = iterateList(ENEMY_PROJ,checkForCollision,self)
    if j ~= -1 then
        table.remove(ENEMY_PROJ,j)
        self:changeHealth(-1)
    end
    if FACE_MOUSE == true then  --if player has toggles FACE_MOUSE on
        --player ship should turn to face mouse pointer
        self:playerTargetMouse()
        self.move_angle  = self.target_angle
        self.print_angle = self.target_angle
    end
    if MOVE == true then
        local x,y  = self:getNewXY(dt)
        self:changeXY(x,y)
    end
end

function PLAYER_SHIP:makePlayer()
    local rand           = math.random
    local ship_type      = "Player"
    local o              = setmetatable(SHIP:new(rand,ship_type,false),PLAYER_SHIP)
    o.shoot_func         = shootSingle
    o.time_between_shots = 0.5
    o.proj_speed         = o.speed * 1.5
    o.target_mouse       = false
    --o.sound          = getSound(moveable) 
   -- o.shoot_func     = getShootFunc(moveable,chase)
    return o
end

