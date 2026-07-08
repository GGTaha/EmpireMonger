extends Control





func _ready() -> void:
	EventBus.NewDay.connect(NewDay)
	#EventBus.AddGold.connect(ResourceUpdated)
	#EventBus.SubtractGold.connect(ResourceUpdated)
	#EventBus.AddBread.connect(ResourceUpdated)
	#EventBus.SubtractBread.connect(ResourceUpdated)
	EventBus.ResourceUpdated.connect(ResourceUpdated)
	EventBus.TroopRecruited.connect(ArmyUpdated)
	EventBus.UpdateProdHud.connect(BuildingUpgraded)
	EventBus.TroopStarved.connect(ArmyUpdated)
	ResourceUpdated("Gold")

func NewDay():
	var Months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
	var total_days: int = RunState.DayNumber
	var Year: int  = total_days / 360
	var Month: int = (total_days % 360) / 30
	var Day: int   = total_days % 30
	#$Calendar.text = str(Day) + " " + Months[Month] + ", " + str(Year) + " AE"
	$Calendar.text = Months[Month] + ", " + str(Year) + " AE"

func BuildingUpgraded():
	$Gold/Prod.text = str(RunState.GoldProduction) + "/Month"
	$Bread/Prod.text = str(RunState.BreadProduction - RunState.Upkeep) + "/Month"

	
	
func ResourceUpdated(resource):
	if resource == "Gold":
		var Gold = RunState.Gold
		$Gold.text = "Gold : " + str(int(round(Gold)))
	if resource == "Bread":
		var Bread = RunState.Bread
		$Bread.text = "Bread : " + str(int(round(Bread)))  #str(Bread)

func ArmyUpdated(a,b,c):
	$Troop.text = "Troops : " + str(RunState.TotalTroops)
	$Bread/Prod.text = str(RunState.BreadProduction - RunState.Upkeep) + "/Month"
	
func _process(delta: float) -> void:
	$Label.text = str(RunState.UnpaidFoodBill)
	
