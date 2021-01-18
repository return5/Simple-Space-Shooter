--File deals with functions involving thruster objects


THRUSTER = {}
THRUSTER.__index = THRUSTER
setmetatable(THRUSTER,OBJECT)


local function getThrusterIcon(rand)
    return love.graphics.newImage("/assets/img/thrusters/thrust_" .. rand(1,5) .. ".png")
end


function THRUSTER:new(x,y,angle,rand)
    local icon = getThrusterIcon(rand)
    local o    = setmetatable(OBJECT:new(x,y,angle,icon),THRUSTER)
    return o
end


