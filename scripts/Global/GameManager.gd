extends Node
var TickCounter = 0
var DayCounter = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.Tick.connect(On_Tick)
	EventBus.GoldProgressed.connect(ProgressGold)
	EventBus.GoldClicked.connect(GoldClicked)

func On_Tick():
	TickCounter += 1
	CountDays()
	

func CountDays():
	if TickCounter >= GameConfig.DayDuration:
		DayCounter += 1
		TickCounter -= GameConfig.DayDuration
		EventBus.NewDay.emit()
		
func GoldClicked():
	EventBus.GoldProgressed.emit(30)
	

func ProgressGold(amount : int):
	RunState.GoldProgress += amount
	if RunState.GoldProgress >= 100:
		RunState.GoldProgress -= 100
		EventBus.AddGold.emit(1)
