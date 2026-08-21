Realtime Rogue-like Strategy Tycoon Game made in Godot 4.7

Fine-tune managing economy, war, and resources.
Framework and template for passive resource generation, troop recruitment and upkeep, and upgrading buildings.

# Game Idea : 

You, as the emperor, have to build mines and farms, recruit troops, and go to battle against other empires. Mines generate gold automatically and can be upgraded. Farms generate Bread automatically and can be upgraded. Garrisons are where your troops and army reside. Recruiting troops requires upfront bread and gold as well as a recurring upkeep of bread. Every month, your troops deduct bread from the store. If you run out of bread and can't pay the bill, the troops starve and desert your army until you can afford your remaining army. The last piece of the puzzle is the expeditions and defences. Use your armies to attack other NPC empires, and defend against NPC attacks. More on expedition mechanics in the next log. Expeditions increase your might, which is the primary indicator of your run's score. 

WORK IN PROGRESS : There is no expedition or Defense system

# How to open project: 
Clone or download this repository locally. 
Open Godot 4.7 (or the latest version).
Click import project and select the repository folder (or select the project.godot file)

# Code : 
- GameManager.gd :
  Contains all the gameplay logic.
- GameClock.gd :
  Contains the timing signals
- EventBus.gd :
  Contains all the signals used.
- GameConfig.gd :
  Contains all the settings and configs. Update this to update all the costs and production.
- RunState.gd :
  Contains the stats and variables in the current run of the game, temporary state of the game.


- main.gd and main.tscn handles the GUI for the main game screen.
- hud.gd/tscn, mine, farm, garrison all handle the GUI and the signals for the respective windows.

- TroopResource :
  to create a new troop, create a new resource file of the type TroopData.gd, and then config the stats.
