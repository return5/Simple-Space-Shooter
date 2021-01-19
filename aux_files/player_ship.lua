--File contains functions related to player ship objects

local Ship = require("aux_files.ship")

PLAYER_SHIP = {}
PLAYER_SHIP.__index = PLAYER_SHIP
setmetatable(PLAYER_SHIP,SHIP)


function PLAYER_SHIP:printPlayer()
    self:printObj()
    if MOVE == true then
        self:printThruster()
    end
end

function PLAYER_SHIP:shootFunc()
    self.shoot_func(PLAYER_PROJ,self)
end

function PLAYER_SHIP:updatePlayer(dt)
    local j = iterateList(ENEMY_PROJ,checkForCollision,self)
    if j ~= -1 then
        table.remove(ENEMY_PROJ,j)
        self:changeHealth(-1)
    end
    playerTargetMouse()
    self:getNewTargetAngle()
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
    --o.sound          = getSound(moveable) 
   -- o.shoot_func     = getShootFunc(moveable,chase)
    return o
end

