--File contains functions for creating the background of game

--list of all background objects
local BG_LIST = {}

--print object to background canvas
local function printBGObj(rand)
    local img   = love.graphics.newImage("/assets/img/planets/planet_icon_" .. rand(1,41) ..".png")
    local angle = -3.14159 + rand() * 6.28318
    love.graphics.draw(img,BG_LIST[#BG_LIST].x,BG_LIST[#BG_LIST].y,angle,nil,nil,img:getWidth() / 2, img:getHeight() / 2)
end

--checks if x,y overlap with another background object
local function checkOverlap(x,y)
    for i=1,#BG_LIST,1 do
        if x <= BG_LIST[i].x + 70 and x >= BG_LIST[i].x - 70 then
            if y <= BG_LIST[i].y + 70 and y >= BG_LIST[i].y - 70 then
                return true
            end
        end
    end
    return false
end

--draw border around game map
local function drawBorderToCanvas()
    love.graphics.setColor(1,1,1)
    love.graphics.setLineWidth(10)
    love.graphics.line(1,1,GAME_W,1)
    love.graphics.line(1,GAME_H,GAME_W,GAME_H)
    love.graphics.line(1,1,1,GAME_H)
    love.graphics.line(GAME_W,1,GAME_W,GAME_H)
end

--gets a new randomly genrated x y for background objext
local function getXY(rand)
    local x,y
    local checkoverlap = checkOverlap
    repeat
        x = rand(1,GAME_W - 40)
        y = rand(1,GAME_H - 40)
    until(checkoverlap(x,y) == false)
    return {x = x,y = y}
end

--create the background for the game
function makeBackground()
    local bg_canvas = love.graphics.newCanvas(GAME_W,GAME_H)
    local rand      = math.random
    local n         = rand(10,30)
    local add       = table.insert
    local getxy     = getXY
    love.graphics.setCanvas(bg_canvas)
    for i=1,n,1 do
        add(BG_LIST,getxy(rand))
        printBGObj(rand)
    end
    drawBorderToCanvas()
    love.graphics.setCanvas()
    return bg_canvas 
end

