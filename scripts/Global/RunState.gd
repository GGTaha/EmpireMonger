extends Node

@export var DayNumber = 0


@export var Gold = 1000
@export var GoldProgress : float = 0.0
@export var GoldMineLevel : int = 0
var GoldProduction : float = 0.0

@export var Bread = 30.0
@export var BreadProgress : float = 0.0
@export var BreadFarmLevel : int = 0
var BreadProduction : float = 0.0

@export var GarrisonLevel : int = 0
# Structure: {"Spearman" : 2, "Archer" : 5}
@export var ArmyRoster: Dictionary = {}
var TotalTroops : int = 0
var Upkeep : float = 0.0 # per Month
var UnpaidFoodBill : float = 0.0
var StarvationGraceUsed : bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.NewDay.connect(NewDay)
	
#	EventBus.AddGold.connect(AddGold)
#	EventBus.SubtractGold.connect(SubtractGold)
	EventBus.GoldUpgraded.connect(UpgradeGold)
	
#	EventBus.AddBread.connect(AddBread)
#	EventBus.SubtractBread.connect(SubtractBread)
	EventBus.BreadUpgraded.connect(UpgradeBread)
	


func NewDay():
	DayNumber += 1
	
func AddGold(amount):
	Gold += amount
	
func SubtractGold(amount):
	Gold -= amount
	
func UpgradeGold(amount: int,success : bool):
	if success: 
		GoldMineLevel += amount
		
		
func AddBread(amount):
	Bread += amount
	
func SubtractBread(amount):
	Bread -= amount
	
func UpgradeBread(amount: int,success : bool):
	if success: 
		BreadFarmLevel += amount
		

	
