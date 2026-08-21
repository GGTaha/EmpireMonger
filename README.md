Realtime Rogue-like Strategy Tycoon Game made in Godot 4.7

Fine-tune managing economy, war, and resources.
Framework and template for passive resource generation, troop recruitment and upkeep, and upgrading buildings.

# Scripts and Scenes : 
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
