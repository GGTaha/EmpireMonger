extends Panel

@onready var GoldBar = $Gold/GoldProgressBar
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.GoldProgressed.connect(ProgressGold)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	$".".hide()


func _on_mine_pressed() -> void:
	EventBus.GoldClicked.emit()

func ProgressGold(amount):
	var progress = RunState.GoldProgress
	var tween = create_tween()
		
		#tween.tween_property(GoldBar, "value", 100, 0.15)
		#tween.tween_property(GoldBar, "value", 0, 0.05)
	tween.tween_property(GoldBar, "value", progress, 0.15)
