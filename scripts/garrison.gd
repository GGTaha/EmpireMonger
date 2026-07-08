extends Panel

@onready var TemplateButton = $Unlocked/Train/TroopSelect/GridContainer/TemplateButton
@onready var ButtonGrid = $Unlocked/Train/TroopSelect/GridContainer
var ActiveTroop : TroopData = GameConfig.TroopFiles[0]

func _ready() -> void:
	LoadMenu()
	EventBus.GarrisonUpgraded.connect(UpgradeGarrison)
	EventBus.TroopRecruited.connect(TroopsUpdated)
	EventBus.TroopStarved.connect(TroopsUpdated)

func _process(delta: float) -> void:
	pass

func _on_unlock_garrison_pressed() -> void:
	EventBus.GarrisonUpgradePressed.emit()

func _on_close_pressed() -> void:
	$".".hide()

func _on_upgrade_garrison_pressed() -> void:
	EventBus.GarrisonUpgradePressed.emit()

func LoadMenu():
	$Level0/UnlockCost.text = str(GameConfig.Garrison.getUpgradeCost(RunState.GarrisonLevel))
	for child in ButtonGrid.get_children():
		if child != TemplateButton:
			child.queue_free()
			
	for troop in GameConfig.TroopFiles:
		var NewButton = TemplateButton.duplicate()
		ButtonGrid.add_child(NewButton)
		NewButton.text = troop.TroopName
		NewButton.show()
		NewButton.pressed.connect(UpdateRecruitMenu.bind(troop))
		
func UpdateRecruitMenu(troop : TroopData):
	ActiveTroop = troop
	$"Unlocked/Train/Troop Recruit/TroopName".text = troop.TroopName
	$"Unlocked/Train/Troop Recruit/TroopDescription".text = troop.TroopDescription
	$"Unlocked/Train/Troop Recruit/Cost".text = str(troop.Cost)
	
	$"Unlocked/Train/Troop Recruit/Stats/Food".text = "FOOD " + str(troop.Upkeep) #+("/DAY")
	$"Unlocked/Train/Troop Recruit/Stats/Health".text = "HEL " + str(troop.LevelData[0].Health)
	
	
	if troop.GarrisonLevel > RunState.GarrisonLevel :
		$"Unlocked/Train/Troop Recruit/RecruitButton".disabled = true
		$"Unlocked/Train/Troop Recruit/RecruitButton".text = "Garrison Level " + str(troop.GarrisonLevel) + " Required"
	else:
		$"Unlocked/Train/Troop Recruit/RecruitButton".disabled = false
		$"Unlocked/Train/Troop Recruit/RecruitButton".text = "Recruit"

func UpgradeGarrison(amount : int, success : bool):
	var UpgradeLabel = $UpgradeSuccess
	var Level = RunState.get("GarrisonLevel")
	if success : 
		if Level > 0:
			$Level0.hide()
			$Unlocked.show()
		$Unlocked/Army/Level.text = "Level " + str(Level)
		$Unlocked/Army/Cost.text = str(GameConfig.Garrison.getUpgradeCost(RunState.GarrisonLevel))
		UpdateRecruitMenu(ActiveTroop)
	
	#Upgrade Label
		UpgradeLabel.text = "Garrison Upgraded!"
		UpgradeLabel.show()
		UpgradeLabel.modulate.a = 1
		var tween = create_tween()
		tween.tween_interval(1.0)
		tween.tween_property(UpgradeLabel, "modulate:a", 0.0, 0.5)
		tween.tween_callback(func(): UpgradeLabel.visible = false)
	if not success:
		UpgradeLabel.text = "Insufficient Gold for Upgrade"
		UpgradeLabel.show()
		UpgradeLabel.modulate.a = 1
		var tween = create_tween()
		tween.tween_interval(1.0)
		tween.tween_property(UpgradeLabel, "modulate:a", 0.0, 0.5)
		tween.tween_callback(func(): UpgradeLabel.visible = false)


func _on_recruit_button_pressed() -> void:
	EventBus.RecruitAttempted.emit(ActiveTroop.TroopName, $"Unlocked/Train/Troop Recruit/RecruitAmount".value)
	
func TroopsUpdated(a, b, c):
	var text = "Current Army Roster : \n"
	for troop in RunState.ArmyRoster:
		text += troop + " : " + str(RunState.ArmyRoster[troop]) + "\n"
	$Unlocked/Army/CurrentGarrison.text = text
	$Unlocked/Army/FoodConsumption.text = "Army Food Consumption : " + str(RunState.Upkeep) + "/Month"
