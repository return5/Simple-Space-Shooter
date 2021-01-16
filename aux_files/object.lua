--File contins parent class for all objects of the game. 

OBJECT = {x = nil, y = nil, x_off = nil, y_off = nil,icon = nil,angle = nil,move_func = nil}
OBJECT.__index = OBJECT


--check to make sure object isnt going into the border, and if not then change x y
function OBJECT:changeXY(new_x,new_y)
    if new_x < 10 or new_x > GAME_W - 10 or new_y < 10 or new_y > GAME_H - 10 then
        return false
    end
    self.x = new_x
    self.y = new_y
    return true
end

--get the new x and y to move a object to
function OBJECT:getNewXY(dt)
    local cos   = math.cos(self.angle)
    local sin   = math.sin(self.angle)
    local new_x = self.x + self.speed * cos * dt
    local new_y = self.y + self.speed * sin * dt
    return new_x,new_y
end

--move in a straight line in direction facing
function OBJECT:moveStraightLine()
    local new_x,new_y = self.getNewXY()
    local succ        = self.changeXY(new_x,new_y) 
    if succ == false then
        getRandomAngle()
    end
    return succ
end

--checks to see if object overlaps another object or if it is at the border
function checkIfOverLap(list,i,params)
    if params.x >= list[i].x - list[i].x_off - 20 and params.x <= list[i].x + list[i].icon:getWidth() + 20 then
        if params.y >= list[i].y - list[i].y_off + 20 and params.y <= list[i].y + list[i].icon:getHeight() + 20 then
            return true
        end
    end
    if params.x < 25 or params.x > GAME_W - 50 or params.y < 25 or params.y > GAME_H - 50 then
        return true
    end

    return false
end

function OBJECT:checkIfAtBorder()
    if self.x + self.x_off <= 10 or self.x + self.x_off >= GAME_W - 10 then
        return true
    end
    if self.y + self.y_off <= 10 or self.y + self.y_off >= GAME_H - 10 then
        return true
    end
    return false
end

--check left and right side of object for collision
local function checkXCollision(obj1,obj2)
    if obj1.x + obj1.x_off >= obj2.x and obj1.x <= obj2.x + obj2.x_off then
        return true
    end
    if obj1.x <= obj2.x and obj1.x + obj1.x_off >= obj2.x + obj2.x_off then
        return true
    end
    return false
end

--check top and bottom of obj for collision
local function checkYCollision(obj1,obj2)
    if obj1.y + obj1.y_off >= obj2.y and obj1.y <= obj2.y + obj2.y_off then
        return true
    end
    if obj1.y <= obj2.y and obj1.y + obj1.self_y >= obj2.y + obj2.self_y then
        return true
    end
    return false
end

--checks to see if two objects have collided
local function checkForCollision(list,i,obj2)
    local obj1 = list[i]
    if obj1 ~= obj2 then
      return checkXCollision(obj1,obj2) and checkYCollison(obj1,obj2)
    end
end

--checks to see if player and object are visible to each other
function isPlayerVisible(obj)
    if PLAYER.x >= obj.x - HALF_W and PLAYER.x <= obj.x + HALF_W then
        if PLAYER.y >= obj.y - HALF_H and PLAYER.y <= obj.y + HALF_H then
            return true
        end
    end
    return false
end

function iterateList(list,func,params)
    for i=#list,1,1 do
        if list[i] ~=nil then
            if func(list,i,params) == true then
                return i
            end
        end
    end
    return -1
end

function OBJECT:printObj()
    love.graphics.draw(self.icon,self.x,self.y,self.angle,nil,nil,self.x_off,self.y_off)
end

function OBJECT:new(x,y,angle,icon)
    local o       = setmetatable({},OBJECT)
    o.icon        = icon
    o.x           = x
    o.y           = y
    o.angle       = angle
    o.x_off       = icon:getWidth() / 2
    o.y_off       = icon:getHeight() / 2
    return o
end



