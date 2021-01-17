--File contains functions for creating the background of game

local Obj  = require("aux_files.object")

--list of all background objects
local BG_LIST = {}

--print object to background canvas
local function getIcon(rand)
    return love.graphics.newImage("/assets/img/planets/planet_icon_" .. rand(1,41) ..".png")
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


--create the background for the game
function makeBackground()
    local bg_canvas = love.graphics.newCanvas(GAME_W,GAME_H)
    local rand      = math.random
    local n         = rand(20,60)
    local add       = table.insert
    local getxy     = getXY
    love.graphics.setCanvas(bg_canvas)
    for i=1,n,1 do
        local x,y    = makeXY(BG_LIST,rand)
        local angle  = getAngle(rand)
        local icon   = getIcon(rand)
        local bg_obj = OBJECT:new(x,y,angle,icon)
        add(BG_LIST,bg_obj)
        bg_obj:printObj()
    end
    drawBorderToCanvas()
    love.graphics.setCanvas()
    return bg_canvas 
end

