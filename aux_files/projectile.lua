local Obj  = require("aux_files.object")


PROJECTILE = {travel_offscreen = nil}
PROJECTILE.__index = PROJECTILE
setmetatable(PROJECTILE,OBJECT)

local function updateProjectile(i)
    if PROJ_LIST[i].move_func(PROJ_LIST[i]) == false then
        table.remove(PROJ_LIST,i)
    else
        local j = iterateList(SHIP_LIST,checkForCollision,PROJ_LIST[i])
        if j ~= -1 then
            table.remove(PROJ_LIST,i)
            SHIP_LIST[i]:changeHealth(-1)
            if SHIP_LIST[i].health == 0 then
                table.remove(SHIP_LIST,j)
            end
        end
    end
        return false
end

function updateAllProjectiles()
    iterateList(PROJ_LIST,upateProjectile,nil)
end

local function getIcon(missle)
    if missle == true then
        return love.graphics.newImage("/assets/img/effects/missle.png")
    else
        return love.graphics.newImage("/assets/img/effects/laser" .. math.random(1,3) .. "png")
    end
end

local function getShootFunc()
    local shootfunc
    return shootfun
end

function PROJECTILE:new(start_x,start_y,angle,t_off,missle,color)
    local icon        = getIcon(missle,color)
    local o           = setmetatable(OBJECT:new(start_x,start_y,angle,icon))
    o.trave_offscreen = t_off
    o.shoot_func      = getShootFunc()
end

