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

local Obj         = require("aux_files.object")
local Proj        = require("aux_files.projectile")
local Enemy_ship  = require("aux_files.enemy_ship")
local Player_ship = require("aux_files.player_ship")
local Background  = require("aux_files.background")

local function printUI()
    love.graphics.print("Player health: " .. PLAYER.health,1,1)
    love.graphics.print("Player Score: " .. PLAYER_SCORE,1,15)
end

function love.draw()
    love.graphics.push()
    love.graphics.translate(-PLAYER.x + HALF_W, -PLAYER.y + HALF_H)
    love.graphics.draw(BG_CANVAS)
    iterateList(SHIP_LIST,printEnemyShip)
    iterateList(PLAYER_PROJ,printProj)
    iterateList(ENEMY_PROJ,printProj)
    PLAYER:printPlayer()
    love.graphics.pop()
    printUI()
end

--get the x and y of mouse pointer
function playerTargetMouse()
    PLAYER.target_x = love.mouse.getX() + PLAYER.x - HALF_W
    PLAYER.target_y = love.mouse.getY() + PLAYER.y - HALF_H
end

function love.keypressed(_,scancode,_)

end

function love.mousepressed(x,y,button,_,_)
    if button == 1 then  --if player pressed left click then shoot a projectile
        PLAYER:shootFunc()
    end

end

function love.update(dt)
    iterateList(SHIP_LIST,updateEnemyShip,dt)    --loop over all enemy ships and update each one
    iterateList(PLAYER_PROJ,updateProjectile,dt) --loop over all player projectiles and update each one
    iterateList(ENEMY_PROJ,updateProjectile,dt)  --loop over each enemy projectile and update each one
    if love.keyboard.isScancodeDown('w') then    -- if player is pressing the 'w' key
        MOVE = true
    else
        MOVE = false
    end
    PLAYER:updatePlayer(dt)
end

function love.load()
    math.randomseed(os.time())
    WINDOW_W      = 900            --size of window width
    WINDOW_H      = 900            --size of window height
    HALF_W        = WINDOW_W / 2   --half of window width
    HALF_H        = WINDOW_H / 2   --half of window height
    GAME_W        = 4000           --width of game map
    GAME_H        = 4000           --height of game map 
    love.window.setMode(WINDOW_W,WINDOW_H)  --set size of window
    BG_CANVAS     = makeBackground()        -- make the background canvas
    SHIP_LIST     = {}  --list of all enemy ships
    PLAYER_PROJ   = {}  --list of projectiles shot by player
    ENEMY_PROJ    = {}  --list of projectiles shot by enemy
    PLAYER        = PLAYER_SHIP:makePlayer()  
    makeEnemyShips()  
    PLAY          = true    --should game keep going
    MOVE          = false   --is player moving
    PLAYER_SCORE  = 0       --player's score
    love.keyboard.setKeyRepeat(true)  --allow player to hold down a key 
   
end
