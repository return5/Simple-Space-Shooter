local Obj  = require("aux_files.object")


PROJECTILE = {travel_offscreen = nil}
PROJECTILE.__index = PROJECTILE
setmetatable(PROJECTILE,OBJECT)

function moveProj(proj,dt)
    if proj.trvel_offscreen == false and proj:isPlayerVisible() == false then
       return false
   else
       return moveStraightLine(proj,dt)
   end

end

function updateProjectile(list,i,dt)
    if list[i]:moveObject(dt) == false then
        table.remove(list,i)
    else
        local j = iterateList(SHIP_LIST,checkForCollision,list[i])
        if j ~= -1 then
            table.remove(list,i)
            SHIP_LIST[j]:changeHealth(-1)
        end
    end
        return false
end

function printProj(list,i,_)
    list[i]:printObj()
end

function updateAllProjectiles()
    iterateList(PROJ_LIST,upateProjectile,nil)
end

function PROJECTILE:new(start_x,start_y,angle,t_off,missle,icon,speed)
    local o           = setmetatable(OBJECT:new(start_x,start_y,angle,icon),PROJECTILE)
    o.trave_offscreen = t_off
    o.move_func       = moveProj
    o.speed           = speed
    return o
end

