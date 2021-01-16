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

local Obj        = require("aux_files.object")
local Ship       = require("aux_files.ship")
local Proj       = require("aux_files.projectile")
local Background = require("aux_files.background")

function love.draw()
    love.graphics.push()
    love.graphics.translate(-PLAYER.x + HALF_W, -PLAYER.y + HALF_H)
    love.graphics.draw(BG_CANVAS)
    iterateList(SHIP_LIST,printShip)
    PLAYER:printPlayer()
    love.graphics.pop()
end

function playerTargetMouse()
    PLAYER.target_x = love.mouse.getX() + PLAYER.x - HALF_W
    PLAYER.target_y = love.mouse.getY() + PLAYER.y - HALF_H
end

function love.keypressed(_,scancode,_)

end

function love.mousepressed(x,y,button,_,_)

end

function love.update(dt)
    iterateList(SHIP_LIST,updateShip,dt)
    if love.keyboard.isScancodeDown('w') then
        MOVE = true
    else
        MOVE = false
    end

    PLAYER:updatePlayer(dt)
end

function love.load()
    math.randomseed(os.time())
    WINDOW_W      = 900 
    WINDOW_H      = 900
    HALF_W        = WINDOW_W / 2
    HALF_H        = WINDOW_H / 2
    GAME_W        = math.random(1000,3000)
    GAME_H        = math.random(1000,3000)
    love.window.setMode(WINDOW_W,WINDOW_H)
    BG_CANVAS     = makeBackground()
    SHIP_LIST     = {}
    PROJ_LIST     = {}
    PLAYER        = SHIP:makePlayer()
    makeEnemyShips()
    PLAY          = true
    MOVE          = false
    PLAYER_SCORE  = 0
    love.keyboard.setKeyRepeat(true)
   
end
