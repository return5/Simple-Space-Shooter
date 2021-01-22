--File fontains functions for creating and manipulaating weapon objects

local Proj = require("aux_files.projectile")

WEAPON = {proj_speed = nil,proj_icon = nil,time_since_shot = nil,time_between_shots = nil,t_off = nil}
WEAPON.__index = WEAPON

CIRCLE_SHOOT = {}
CIRCLE_SHOOT.__index = CIRCLE_SHOOT
setmetatable(CIRCLE_SHOOT,WEAPON)

SINGLE_SHOOT = {}
SINGLE_SHOOT.__index = SINGLE_SHOOT
setmetatable(SINGLE_SHOOT,WEAPON)

MULTI_SHOOT = {}
MULTI_SHOOT.__index = MULTI_SHOOT
setmetatable(MULTI_SHOOT,WEAPON)

UFO_SHOOT = {}
UFO_SHOOT.__index = UFO_SHOOT
setmetatable(UFO_SHOOT,WEAPON)

local PROJ_COLORS = {"blue","red","green","yellow"}

function SINGLE_SHOT:shootFunc(ship,list) 
    if love.timer.getTime() - self.time_since_shot > self.time_between_shots then
        table.insert(list,PROJECTILE:new(ship.x,ship.y,ship.target_angle,self.t_off,self.proj_icon,self.proj_speed))
        self.time_since_shot = love.timer.getTime()
    end
end

function CIRCLE_SHOOT:shootFunc(ship,list)
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

function CIRCLE_SHOOT:new(rand)
    local o = setmetatable(WEAPON:new(rand),CIRCLE_SHOOT)
    return o
end

function SINGLE_SHOOT:new(rand)
    local o = setmetatable(WEAPON:new(rand),SINGLE_SHOOT)
    return o
end

function MULTI_SHOOT:new(rand)
    local o = setmetatable(WEAPON:new(rand),MULTI_SHOOT)
    return o
end

function UFO_SHOOT:new(rand)
    local o = setmetatable(WEAPON:new(rand),UFO_SHOOT)
    return o
end

local function getProjIcon(rand,missile)
    local color = PROJ_COLORS[rand(1,#PROJ_COLORS)]
    local icon 
    if missile == true then
        icon = "/assets/img/weapons/missile_" .. color .. ".png"
    else
        icon = "/assets/img/weapons/laser_" .. color .. ".png"
    end
    return love.graphics.newImage(icon)
end

function WEAPON:new(rand)
    local o       = setmetatable({},WEAPON)
    local missile = rand(1,3) < 2
    o.proj_icon   = getProjIcon(rand,missile)
    o.t_off       = rand(1,3) < 2
    return o
end

