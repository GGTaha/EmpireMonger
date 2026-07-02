extends Panel
var current_visual: float = 0.0
var target_total: float = 0.0
var OldGold: float = 0.0
var gold_tween: Tween

@onready var GoldBar = $Gold/GoldProgressBar
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.VisualiseGoldProgress.connect(ProgressGold)
	EventBus.GoldUpgraded.connect(UpgradeGold)
	$Gold/Cost.text = "Cost : " + str(GameConfig.GoldMine.getUpgradeCost(RunState.GoldMineLevel))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	$".".hide()


func _on_mine_pressed() -> void:
	EventBus.GoldClicked.emit()

func ProgressGold(new_progress: float, wraps: int):
	var progress_added = (wraps * 100.0) + new_progress - OldGold
	target_total += progress_added
	OldGold = new_progress
	
	if gold_tween and gold_tween.is_valid():
		gold_tween.kill()
		
	gold_tween = create_tween()
	
	gold_tween.tween_method(update_visual_bar, current_visual, target_total, 0.15)

func update_visual_bar(animated_value: float):

	current_visual = animated_value 
	$Gold/GoldProgressBar.value = fmod(animated_value, 100.0)

func _on_gold_mine_upgrade_pressed() -> void:
	EventBus.GoldUpgradePressed.emit()
	
func UpgradeGold(amount: int,success : bool):
	var UpgradeLabel = $Gold/UpgradeSuccess
	if not success:
		UpgradeLabel.text = "Insufficient Gold for Upgrade"
		UpgradeLabel.show()
		UpgradeLabel.modulate.a = 1
		var tween = create_tween()
		tween.tween_interval(1.0)
		tween.tween_property(UpgradeLabel, "modulate:a", 0.0, 0.5)
		tween.tween_callback(func(): UpgradeLabel.visible = false)
	else:
		UpgradeLabel.text = "Gold Mine Upgraded!"
		UpgradeLabel.show()
		UpgradeLabel.modulate.a = 1
		var tween = create_tween()
		tween.tween_interval(1.0)
		tween.tween_property(UpgradeLabel, "modulate:a", 0.0, 0.5)
		tween.tween_callback(func(): UpgradeLabel.visible = false)
		$Level.text = "Level " + str(RunState.GoldMineLevel)
		$Gold/Cost.text = "Cost : " + str(GameConfig.GoldMine.getUpgradeCost(RunState.GoldMineLevel))
	var goldProduction : float = GameConfig.GoldMine.getPayout(RunState.GoldMineLevel)* (GameConfig.GoldMine.getProductionSpeed(RunState.GoldMineLevel)/100.0) * GameConfig.DayDuration
	$Production.text = "Passive Gold Production : " + str(goldProduction) + " Gold/Day"
		
	
