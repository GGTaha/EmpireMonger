extends Panel
var current_visual: float = 0.0
var target_total: float = 0.0
var OldBread: float = 0.0
var Bread_tween: Tween

@onready var BreadBar = $Bread/BreadProgressBar
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.VisualiseBreadProgress.connect(ProgressBread)
	EventBus.BreadUpgraded.connect(UpgradeBread)
	$Bread/Cost.text = "Cost : " + str(GameConfig.BreadFarm.getUpgradeCost(RunState.BreadFarmLevel))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_farm_pressed() -> void:
	EventBus.BreadClicked.emit()

func ProgressBread(new_progress: float, wraps: int):
	var progress_added = (wraps * 100.0) + new_progress - OldBread
	target_total += progress_added
	OldBread = new_progress
	
	if Bread_tween and Bread_tween.is_valid():
		Bread_tween.kill()
		
	Bread_tween = create_tween()
	
	Bread_tween.tween_method(update_visual_bar, current_visual, target_total, 0.15)

func update_visual_bar(animated_value: float):

	current_visual = animated_value 
	$Bread/BreadProgressBar.value = fmod(animated_value, 100.0)

func _on_bread_farm_upgrade_pressed() -> void:
	EventBus.BreadUpgradePressed.emit()
	
func UpgradeBread(amount: int,success : bool):
	var UpgradeLabel = $Bread/UpgradeSuccess
	if not success:
		UpgradeLabel.text = "Insufficient Gold for Upgrade"
		UpgradeLabel.show()
		UpgradeLabel.modulate.a = 1
		var tween = create_tween()
		tween.tween_interval(1.0)
		tween.tween_property(UpgradeLabel, "modulate:a", 0.0, 0.5)
		tween.tween_callback(func(): UpgradeLabel.visible = false)
	else:
		UpgradeLabel.text = "Bread Farm Upgraded!"
		UpgradeLabel.show()
		UpgradeLabel.modulate.a = 1
		var tween = create_tween()
		tween.tween_interval(1.0)
		tween.tween_property(UpgradeLabel, "modulate:a", 0.0, 0.5)
		tween.tween_callback(func(): UpgradeLabel.visible = false)
		$Level.text = "Level " + str(RunState.BreadFarmLevel)
		$Bread/Cost.text = "Cost : " + str(GameConfig.BreadFarm.getUpgradeCost(RunState.BreadFarmLevel))
	var BreadProduction : float = GameConfig.BreadFarm.getPayout(RunState.BreadFarmLevel)* (GameConfig.BreadFarm.getProductionSpeed(RunState.BreadFarmLevel)/100.0) * GameConfig.DayDuration * 30
	RunState.BreadProduction = BreadProduction
	$Production.text = "Passive Bread Production : " + str(BreadProduction) + " Bread/Month"
	EventBus.UpdateProdHud.emit()
		
	


func _on_close_pressed() -> void:
	$".".hide()
