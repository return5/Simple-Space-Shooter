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
local S_Rocket    = require("aux_files.stationary_rocket")
local M_Rocket    = require("aux_files.moving_rocket")
local Station     = require("aux_files.station")
local Satellite   = require("aux_files.satellite")
local Powerup     = require("aux_files.powerup")
local GAME_OVER   = false

local function printUI()
    love.graphics.print("Player health: " .. PLAYER.health,1,1)
    love.graphics.print("Player Score: " .. PLAYER_SCORE,1,15)
    love.graphics.print("enemies left: " .. #SHIP_LIST,1,30)
end

local function printGameOver()
    local big_font   = love.graphics.newFont(20)
    local norm_font  = love.graphics.newFont()
    local r,g,b,a    = love.graphics.getColor()
    local str        = "GAME OVER!"
    local middle_h   = WINDOW_H / 3 
    local middle_w   = WINDOW_W / 2
    local str_w_m    = big_font:getWidth(str) / 2
    love.graphics.setFont(big_font)
    love.graphics.setColor(1.0,0.2,0.2,a)
    love.graphics.print(str,(middle_w) - (str_w_m), middle_h)
    love.graphics.setFont(norm_font)
    love.graphics.setColor(r,g,b,a)
    love.graphics.print("Player final score: " .. PLAYER_SCORE,middle_w - str_w_m,middle_h + big_font:getHeight() + 10)
    love.graphics.print("please press any key to exit.",middle_w - str_w_m,middle_h + big_font:getHeight() + norm_font:getHeight() + 20)
end

function love.draw()
    if GAME_OVER == false then
        love.graphics.push()
        love.graphics.translate(-PLAYER.x + HALF_W, -PLAYER.y + HALF_H)
        love.graphics.draw(BG_CANVAS)
        iterateList(SHIP_LIST,printObject)
        iterateList(PLAYER_PROJ,printObject)
        iterateList(ENEMY_PROJ,printObject)
        iterateList(POWERUP_LIST,printObject)
        PLAYER:printPlayer()
        love.graphics.pop()
        printUI()
    else
        printGameOver()
    end

end


function love.keypressed(_,scancode,_)
    if GAME_OVER == true then
        love.event.quit(0)
    end

end

function love.mousepressed(x,y,button,_,_)
    if button == 1 then  --if player pressed left click then shoot a projectile
        PLAYER:shootFunc()
    end
    if button == 2 then
        FACE_MOUSE = not FACE_MOUSE 
    end
end

local function makePowerup()
    if math.random(1,100) < 1 then
        table.insert(POWERUP_LIST,POWERUP:new(math.random))
    end
end

function love.update(dt)
    if PLAYER.health <= 0 or #SHIP_LIST <=0  then
        GAME_OVER = true
        love.keyboard.setKeyRepeat(false)  
    else
        makePowerup()
        iterateList(SHIP_LIST,updateObject,dt)    --loop over all enemy ships and update each one
        iterateList(PLAYER_PROJ,updateObject,dt) --loop over all player projectiles and update each one
        iterateList(ENEMY_PROJ,updateObject,dt)  --loop over each enemy projectile and update each one
        if love.keyboard.isScancodeDown('w') then    -- if player is pressing the 'w' key
            MOVE = true
        else
            MOVE = false
        end
        if love.keyboard.isScancodeDown("a") then  --if player presses 'a' key
            PLAYER.move_angle = PLAYER.move_angle - 0.08726646 --rotate players ship by 5 degrees
        elseif love.keyboard.isScancodeDown('d') then
            PLAYER.move_angle = PLAYER.move_angle + 0.08726646
        end
        PLAYER:updatePlayer(dt)
    end
end

--make list of enemy ships
local function makeEnemyShips()
    local rand = math.random
    local add  = table.insert
    local n    = rand(20,40)
    for i=1,n,1 do
        local j = rand(0,13)
        if j < 3 then
            add(SHIP_LIST,FIGHTER:new(rand))
        elseif j < 5 then
            add(SHIP_LIST,STATION:new(rand))
        elseif j < 7 then
            add(SHIP_LIST,STATIONARY_ROCKET:new(rand))
         elseif j < 9 then
            add(SHIP_LIST,MOVING_ROCKET:new(rand))
        elseif j < 11 then
            add(SHIP_LIST,SATELLITE:new(rand))
        else
            add(SHIP_LIST,UFO:new(rand))
        end
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
    POWERUP_LIST  = {}
    MAX_SPEED     = 300
    PLAYER        = PLAYER_SHIP:makePlayer()  
    MAX_SPEED     = PLAYER.speed  --ensure that no enemy ship can travel faster than player ship
    makeEnemyShips()  
    PLAY          = true    --should game keep going
    MOVE          = false   --is player moving
    FACE_MOUSE    = true    --should player ship face the mouse pointer
    PLAYER_SCORE  = 0       --player's score
    love.keyboard.setKeyRepeat(true)  --allow player to hold down a key 
   
end
