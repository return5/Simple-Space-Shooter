## Introduction  
   Simple Space shooter is a simplistic 2D shooter set in space.  
   The player controls a single ship. Player flys their ship through space shooting other ships and attempting to not be shot themself.  
   There are a variety of enemy types and models. With each new game the types and models are randomly selected.  
   The number of Enemy ships and their attributes are all randomly assigned at the start of a new game.  
   The Background of each new game is also randomized with each new game.  
   
   Game can be played on the web at: [itch.io](https://return5.itch.io/simple-space-shooter)

   Game includes [tick module](https://github.com/rxi/tick) and [Lume module](https://github.com/rxi/lume) both files included under 'aux_files' directory.  


## controls  
'w' - moves player ship forward.  
'left mouse button' - fire ship weapon.  
 move mouse cursor to move ship.  
'right mouse button' - enables free movement of mouse cursor. ship no longers follows mouse cursor.press button again to return to normal mode.  
'a' and 'd' - rotate ship left/right after player presses 'right mouse button'.  

## Power Ups  

### Restore health  
![screenshot_restorehealth](/assets/img/power_ups/restore_health_powerup.png)  
This power up restores 2 health when collected.  

### Invulnerability  
![screenshot_temphealth](/assets/img/power_ups/temp_health_powerup.png)  
This power up grants temporary invulnerability when collected.  

### Increases speed  
![screenshot_increasespeed](/assets/img/power_ups/speed_boost_powerup.png)  
This power up gives a temporary boost to ship speed when collected.  

### Spread Shot  
![screenshot_multishot](/assets/img/power_ups/multi_shot_powerup.png)  
This power up gives a temporary spread shot when collected. 

### Mouse Aiming  
![screenshot_targetmouse](/assets/img/power_ups/target_mouse_powerup.png)  
This power up gives a temporary ability ot aim with the mouse.  
After collecting, press right mouse button and shots will target the mouse cursor.  
also gives a temporary boost in firing speed.   

## Dependencies   
- [Lua](https://www.lua.org/)  
- [Love2d](https://love2d.org/)  


## Screenshots  
  ![screenshot1](/assets/img/screenshots/screenshot_1.png)  

  ![screenshot2](/assets/img/screenshots/screenshot_2.png)  

  ![screenshot3](/assets/img/screenshots/screenshot_3.png)  

## To Do 
- [x] add gameover screen.  
    - [x] gameover happens when either player health drops to 0 or all enemies are destroyed.  
- [x] add counter to show # of enemies left.  
- [ ] when only a few enemies left add arrow to screen pointing to nearest enemy.  
- [ ] add sounds.  
    - [x] add sounds for lasers.  
    - [ ] add sounds for ship destroyed.  
    - [x] add sound for picking up power up.  
    - [x] add sound for ship thrusters.  
    - [x] add ufo flying noise.  
- [ ] add background music.  
- [x] add powerups to game.   
    - [x] powerup icons.  
    - [x] add randomly selected powerups to game at random intervals.  
    - [x] powerups disappear after a given time interveral.  
    - [x] powerup functions which last for a limited time.  
- [ ] add explosion when ship is destroyed.  

## CREDITS  
credit for the graphic and sound assets as well as the included modules goes to:  
- [kenney](https://kenney.nl/) (if you happen to read this, you rock)  
- [turkkub](https://www.flaticon.com/packs/universe-28?word=space)  
- [monkik](https://www.flaticon.com/packs/space-85?word=space)  
- [photo3idea_studio](https://www.flaticon.com/packs/space-126?word=space)  
- [icongeek26](https://www.flaticon.com/packs/space-230?word=space)  
- [freepik](https://www.flaticon.com/packs/space-elements?word=space&k=1609880618970)  
- [tick](https://github.com/rxi/tick)
- [Lume](https://github.com/rxi/lume)
- [ufo sound effect](https://soundbible.com/146-UFO-Exit.html) (sound effect in game is slightly edited by me.)  
- [Ship thruster sound effect](https://soundbible.com/1492-Rocket-Thrusters.html)  

All Assets are subject to their own Licenses seperate from that of the code.  
    
## License  
All code in this project written by me (that is everything except for lume and tick) is license under the [GPL 3.0 license.](https://www.gnu.org/licenses/gpl-3.0.en.html)  
Licenses for graphics,sounds,and included modules is to be found in the hyperlinks given above.  
