extends Node
@export var DayNumber = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.NewDay.connect(NewDay)



func NewDay():
	DayNumber += 1
	print(DayNumber)
	
