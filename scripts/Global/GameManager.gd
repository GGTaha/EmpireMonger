extends Node
var TickCounter = 0
var DayCounter = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.Tick.connect(On_Tick)
	EventBus.GoldProgressed.connect(ProgressGold)
	EventBus.GoldClicked.connect(GoldClicked)
	EventBus.GoldUpgradePressed.connect(UpgradeGold)

func On_Tick():
	TickCounter += 1
	CountDays()
	MineGold()

func CountDays():
	if TickCounter >= GameConfig.DayDuration:
		DayCounter += 1
		TickCounter -= GameConfig.DayDuration
		EventBus.NewDay.emit()
		
func GoldClicked():
	EventBus.GoldProgressed.emit(GameConfig.GoldClickAmount)
	

func ProgressGold(amount : int):
	RunState.GoldProgress += amount
	var wraps: int = 0
	while RunState.GoldProgress >= 100.0:
		RunState.GoldProgress -= 100.0
		wraps += 1
		EventBus.AddGold.emit(GameConfig.GoldMine.getPayout(RunState.GoldMineLevel))
	EventBus.VisualiseGoldProgress.emit(RunState.GoldProgress, wraps)

func MineGold():
	if GameConfig.GoldMine.isAutomatic(RunState.GoldMineLevel):
		EventBus.GoldProgressed.emit(GameConfig.GoldMine.getProductionSpeed(RunState.GoldMineLevel))
		
func UpgradeGold():
	var cost = GameConfig.GoldMine.getUpgradeCost(RunState.GoldMineLevel)
	if cost > RunState.Gold:
		EventBus.GoldUpgraded.emit(0, false)
	else:
		EventBus.GoldUpgraded.emit(1,true)
		EventBus.SubtractGold.emit(cost)
