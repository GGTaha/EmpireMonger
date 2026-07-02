extends Node
signal Tick
signal NewDay
signal AddGold(amount : int)
signal SubtractGold(amount : int)
signal GoldClicked()
signal GoldProgressed()
signal VisualiseGoldProgress(amount : int, wraps : int)
signal GoldUpgradePressed()
signal GoldUpgraded(amount : int, success : bool)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
