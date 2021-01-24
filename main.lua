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

local Proj        = require("aux_files.projectile")
local Ufo         = require("aux_files.ufo")
local Player_ship = require("aux_files.player_ship")
local Background  = require("aux_files.background")
local Fighter     = require("aux_files.fighter")
local Stationary  = require("aux_files.stationary")
local Satellite   = require("aux_files.satellite")

local function printUI()
    love.graphics.print("Player health: " .. PLAYER.health,1,1)
    love.graphics.print("Player Score: " .. PLAYER_SCORE,1,15)
end

function love.draw()
    love.graphics.push()
    love.graphics.translate(-PLAYER.x + HALF_W, -PLAYER.y + HALF_H)
    love.graphics.draw(BG_CANVAS)
    iterateList(SHIP_LIST,printObject)
   -- iterateList(PLAYER_PROJ,printProj)
    iterateList(ENEMY_PROJ,printObject)
    PLAYER:printPlayer()
    love.graphics.pop()
    printUI()
end


function love.keypressed(_,scancode,_)

end

function love.mousepressed(x,y,button,_,_)
    if button == 1 then  --if player pressed left click then shoot a projectile
        PLAYER:shootFunc()
    end
    if button == 2 then
        FACE_MOUSE = not FACE_MOUSE 
    end

end

function love.update(dt)
    iterateList(SHIP_LIST,updateObject,dt)    --loop over all enemy ships and update each one
    iterateList(PLAYER_PROJ,updateObject,dt) --loop over all player projectiles and update each one
    iterateList(ENEMY_PROJ,updateObject,dt)  --loop over each enemy projectile and update each one
    if love.keyboard.isScancodeDown('w') then    -- if player is pressing the 'w' key
        MOVE = true
    else
        MOVE = false
    end
    if love.keyboard.isScancodeDown("a") then  --if player presses 'a' key
        PLAYER.move_angle = PLAYER.move_angle - 0.174532 --rotate players ship by 25 degrees
    elseif love.keyboard.isScancodeDown('d') then
        PLAYER.move_angle = PLAYER.move_angle + 0.174532--0.43633
    end
    PLAYER:updatePlayer(dt)
end

--make list of enemy ships
local function makeEnemyShips()
    local rand = math.random
    local add  = table.insert
    local n    = rand(20,60)
    n = 20
    for i=1,n,1 do
        local i = rand(1,8)
        --if i < 3 then
           -- add(SHIP_LIST,FIGHTER:new(rand))
      --  elseif i < 5 then
          -- add(SHIP_LIST,STATIONARY:new(rand))
      --  elseif i < 8 then
         --add(SHIP_LIST,SATELLITE:new(rand))
       -- else
           add(SHIP_LIST,UFO:new(rand))
      --  end
    end
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
    MAX_SPEED     = 275
    PLAYER        = PLAYER_SHIP:makePlayer()  
    MAX_SPEED     = PLAYER.speed
    makeEnemyShips()  
    PLAY          = true    --should game keep going
    MOVE          = false   --is player moving
    FACE_MOUSE    = true    --should player ship face the mouse pointer
    PLAYER_SCORE  = 0       --player's score
    love.keyboard.setKeyRepeat(true)  --allow player to hold down a key 
   
end
