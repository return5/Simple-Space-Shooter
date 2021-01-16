--[[
        Simple Space Shooter. A simple game about flying around space and shooting things. please see git repo at: https://github.com/return5/Simple-Space-Shooter
        Licenses under GPL 3.0:
            Copyright (C) <2021>  <return5>

            This program is free software: you can redistribute it and/or modify
            it under the terms of the GNU General Public License as published by
            the Free Software Foundation, either version 3 of the License, or
            (at your option) any later version.

            This program is distributed in the hope that it will be useful,
            but WITHOUT ANY WARRANTY; without even the implied warranty of
            MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
            GNU General Public License for more details.

            You should have received a copy of the GNU General Public License
            along with this program.  If not, see <https://www.gnu.org/licenses/>.
--]]

local Moving     = require("aux_files.ship")
local Stationary = require("aux_files.projectile")
local Background = require("aux_files.background")

function love.draw()
    love.graphics.push()
    love.graphics.translate(-PLAYER.x + HALF_W, -PLAYER.y + HALF_H)
    love.graphics.draw(BG_CANVAS)
    love.graphics.setCanvas()
    PLAYER:printObj()
    PLAYER:printThruster()
    love.graphics.pop()
end

local function playerTargetMouse()
    PLAYER.target_x = love.mouse.getX() + PLAYER.x - HALF_W
    PLAYER.target_y = love.mouse.getY() + PLAYER.y - HALF_H
end

function love.keypressed(_,scancode,_)
    if scancode == "w" then
        MOVE = true
    else
        MOVE = false
    end

end

function love.mousepressed(x,y,button,_,_)

end

function love.update(dt)
    playerTargetMouse()
    PLAYER:getNewAngle()
    if MOVE == true then
        local x,y  = PLAYER:getNewXY(dt)
        PLAYER:changeXY(x,y)
    end
end

function love.load()
    math.randomseed(os.time())
    WINDOW_W  = 900 
    WINDOW_H  = 900
    HALF_W    = WINDOW_W / 2
    HALF_H    = WINDOW_H / 2
    GAME_W    = 4000
    GAME_H    = 4000
    love.window.setMode(WINDOW_W,WINDOW_H)
    love.keyboard.setKeyRepeat(true)
    BG_CANVAS = makeBackground()
    SHIP_LIST = {}
    PROJ_LIST = {}
    PLAYER    = SHIP:new()
    --ENEMIES   = makeEnemies()
    PLAY      = true
    MOVE = false

end
