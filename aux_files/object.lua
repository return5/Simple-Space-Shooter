
OBJECT = {x = nil, y = nil, x_off = nil, y_off = nil,icon = nil,move_angle = nil,move_func = nil}
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
    local cos   = math.cos(self.move_angle)
    local sin   = math.sin(self.move_angle)
    local new_x = self.x + self.speed * cos * dt
    local new_y = self.y + self.speed * sin * dt
    return new_x,new_y
end

--move in a straight line in direction facing
function OBJECT:moveStraightLine(dt)
    local new_x,new_y = self:getNewXY(dt)
    return self:changeXY(new_x,new_y) 
end

--checks to see if object overlaps another object
function checkIfOverLap(list,i,params)
    if params.x >= list[i].x  - 210 and params.x <= list[i].x + 210 then
        if params.y >= list[i].y - 210 and params.y <= list[i].y + 210 then
            return true
        end
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
    if obj1.x <= obj2.x + obj2.icon:getWidth() and obj1.x + obj1.icon:getWidth() >= obj2.x then
        return true
    end
    return false
end

--check top and bottom of obj for collision
local function checkYCollision(obj1,obj2)
    if obj1.y  <= obj2.y + obj2.icon:getHeight() and obj1.y + obj1.icon:getHeight() >= obj2.y   then
        return true
    end
    return false
end

--checks to see if two objects have collided
function checkForCollision(list,i,obj2)
    local obj1 = list[i]
    if obj1 ~= obj2 then
      return checkXCollision(obj1,obj2) and checkYCollision(obj1,obj2)
    end
end

--checks to see if player and object are visible to each other
function OBJECT:isPlayerVisible()
    if PLAYER.x >= self.x - HALF_W and PLAYER.x <= self.x + HALF_W then
        if PLAYER.y >= self.y - HALF_H and PLAYER.y <= self.y + HALF_H then
            return true
        end
    end
    return false
end

function OBJECT:printObj()
    love.graphics.draw(self.icon,self.x,self.y,self.move_angle,nil,nil,self.x_off,self.y_off)
end

function printObject(list,i,_)
    list[i]:print_func()
    return false
end

function moveObj(list,i,dt)
    list[i]:move_func(dt)
    return false
end


function updateObject(list,i,dt)
    list[i]:update(list,i,dt)
end

function iterateList(list,func,params)
    if list ~= nil then
        for i=#list,1,-1 do
            if list[i] ~= nil then
                if func(list,i,params) == true then
                    return i
                end
            end
        end
    end
    return -1
end

function getAngle(rand)
    return -3.14159 + rand() * 6.28318
end

function makeXY(list,rand)
    local params  = {x = nil, y = nil}
    local func    = checkIfOverLap
    local iteratelist = iterateList
    repeat
        params.x = rand(50,GAME_W - 50)
        params.y = rand(50,GAME_H - 50)
    until(iteratelist(list,func,params) == -1)
    return params.x,params.y
end

function OBJECT:new(x,y,angle,icon)
    local o       = setmetatable({},OBJECT)
    o.icon        = icon
    o.x           = x
    o.y           = y
    o.move_angle  = angle
    o.x_off       = icon:getWidth() / 2
    o.y_off       = icon:getHeight() / 2
    o.print_func  = OBJECT.printObj
    return o
end



