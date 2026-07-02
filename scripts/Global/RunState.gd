extends Node

@export var DayNumber = 0


@export var Gold = 0
@export var GoldProgress : int = 0
@export var GoldMineLevel : int = 0



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.NewDay.connect(NewDay)
	EventBus.AddGold.connect(AddGold)
	EventBus.SubtractGold.connect(SubtractGold)
	EventBus.GoldUpgraded.connect(UpgradeGold)
	


func NewDay():
	DayNumber += 1
	
func AddGold(amount):
	Gold += amount
	
func SubtractGold(amount):
	Gold -= amount
	
func UpgradeGold(amount: int,success : bool):
	if success: 
		GoldMineLevel += amount
		
		

	
