extends Node
var TickCounter = 0
var DayCounter = 0

var BillCounter = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.Tick.connect(On_Tick)
	
	EventBus.GoldProgressed.connect(ProgressGold)
	EventBus.GoldClicked.connect(GoldClicked)
	EventBus.GoldUpgradePressed.connect(UpgradeGold)
	
	EventBus.BreadProgressed.connect(ProgressBread)
	EventBus.BreadClicked.connect(BreadClicked)
	EventBus.BreadUpgradePressed.connect(UpgradeBread)

	EventBus.GarrisonUpgradePressed.connect(UpgradeGarrison)
	EventBus.RecruitAttempted.connect(RecruitTroops)
	

func On_Tick():
	TickCounter += 1
	CountDays()
	MineGold()
	FarmBread()
	FeedTroops()

func CountDays():
	if TickCounter >= GameConfig.DayDuration:
		DayCounter += 1
		TickCounter -= GameConfig.DayDuration
		EventBus.NewDay.emit()


#===================================
#Gold Mines
#===================================	
#region 
func GoldClicked():
	EventBus.GoldProgressed.emit(GameConfig.GoldClickAmount)
	

func ProgressGold(amount : int):
	RunState.GoldProgress += amount
	var wraps: int = 0
	while RunState.GoldProgress >= 100.0:
		RunState.GoldProgress -= 100.0
		wraps += 1
		ModifyResource("Gold", GameConfig.GoldMine.getPayout(RunState.GoldMineLevel))
	EventBus.VisualiseGoldProgress.emit(RunState.GoldProgress, wraps)

func MineGold():
	if GameConfig.GoldMine.isAutomatic(RunState.GoldMineLevel):
		EventBus.GoldProgressed.emit(GameConfig.GoldMine.getProductionSpeed(RunState.GoldMineLevel))
		
func UpgradeGold():
	var cost = GameConfig.GoldMine.getUpgradeCost(RunState.GoldMineLevel)
	if not AttemptPurchase(cost):
		EventBus.GoldUpgraded.emit(0, false)
	else:
		EventBus.GoldUpgraded.emit(1,true)
#endregion


#===================================
#Bread Farms
#===================================	
#region 
func BreadClicked():
	EventBus.BreadProgressed.emit(GameConfig.BreadClickAmount)
	

func ProgressBread(amount : int):
	RunState.BreadProgress += amount
	var wraps: int = 0
	while RunState.BreadProgress >= 100.0:
		RunState.BreadProgress -= 100.0
		wraps += 1
		ModifyResource("Bread", GameConfig.BreadFarm.getPayout(RunState.BreadFarmLevel))
	EventBus.VisualiseBreadProgress.emit(RunState.BreadProgress, wraps)

func FarmBread():
	if GameConfig.BreadFarm.isAutomatic(RunState.BreadFarmLevel):
		EventBus.BreadProgressed.emit(GameConfig.BreadFarm.getProductionSpeed(RunState.BreadFarmLevel))
		
func UpgradeBread():
	var cost = GameConfig.BreadFarm.getUpgradeCost(RunState.BreadFarmLevel)
	if not AttemptPurchase(cost):
		EventBus.BreadUpgraded.emit(0, false)
	else:
		EventBus.BreadUpgraded.emit(1,true)
#endregion


func AttemptPurchase(cost_dict: Dictionary) -> bool:
	
	for resource_name in cost_dict.keys():
		var required_amount = cost_dict[resource_name]
		var player_balance = RunState.get(resource_name)
		if player_balance < required_amount:
			return false
			
	for resource_name in cost_dict.keys():
		var required_amount = cost_dict[resource_name]
		var current_balance = RunState.get(resource_name)
		ModifyResource(resource_name, -required_amount)
		EventBus.ResourceUpdated.emit(resource_name)

	
	return true

func ModifyResource(resource, amount : float):
	var CurrentBalance = RunState.get(resource)
	var NewBalance = CurrentBalance + amount
	
	#NO DEBT EVER NOT SURE
	if NewBalance < 0:
		NewBalance = 0
	
	RunState.set(resource, NewBalance)
	EventBus.ResourceUpdated.emit(resource)


func UpgradeGarrison():
	
	var cost = GameConfig.Garrison.getUpgradeCost(RunState.GarrisonLevel)
	if AttemptPurchase(cost):
		RunState.GarrisonLevel += 1
		EventBus.GarrisonUpgraded.emit(1, true)
	else:
		EventBus.GarrisonUpgraded.emit(0, false)


func RecruitTroops(TroopName : String, Amount : int):
	var TroopType : TroopData = GameConfig.Troops[TroopName]
	var cost : Dictionary = {}
	for res in TroopType.Cost:
		cost[res] = TroopType.Cost[res] * Amount
		
	if AttemptPurchase(cost):
		print("Bought")
		ModifyArmy(TroopName,Amount)
		EventBus.TroopRecruited.emit(TroopName, Amount, true)

	else:
		print("Not Enough Resources")
		EventBus.TroopRecruited.emit(TroopName, Amount, false)
	

func ModifyArmy(Troop, amount):
	var CurrentAmount = RunState.ArmyRoster.get(Troop,0)
	var setAmount = CurrentAmount + amount
	RunState.TotalTroops += amount
	if RunState.TotalTroops < 0:
		RunState.TotalTroops = 0
	if setAmount <0:
		setAmount = 0
	RunState.ArmyRoster[Troop] = setAmount
	CalculateArmyUpkeep()


func CalculateArmyUpkeep():
	var TotalRosterFood = 0
	for troop in RunState.ArmyRoster:
		var food = GameConfig.Troops[troop].Upkeep * RunState.ArmyRoster[troop]
		TotalRosterFood += food
	RunState.Upkeep = TotalRosterFood


func FeedTroops():
	var CurrentBill : float = RunState.Upkeep / (GameConfig.DayDuration * 30.0) #converting months to ticks
	
	#Check if Army is empty
	var ArmyEmpty = true
	if not RunState.ArmyRoster.is_empty():
		for amount in RunState.ArmyRoster.values():
			if amount > 0:
				ArmyEmpty = false
				break
				
				
	#If army is not empty, make bill
	if not ArmyEmpty or RunState.UnpaidFoodBill > 0:
		BillCounter += 1
		RunState.UnpaidFoodBill += CurrentBill
		if BillCounter > (GameConfig.DayDuration * 30):
			
			if RunState.Bread < RunState.UnpaidFoodBill:
				if not RunState.StarvationGraceUsed:
					RunState.StarvationGraceUsed = true
					
				else:
					StarveTroops(RunState.UnpaidFoodBill - RunState.Bread)
			else:
				
				if RunState.StarvationGraceUsed == true:
					RunState.StarvationGraceUsed = false
			
			ModifyResource("Bread", -RunState.UnpaidFoodBill)
			RunState.UnpaidFoodBill = 0 #Bill paid
			BillCounter -= GameConfig.DayDuration * 30


func StarveTroops(shortfall: float) -> void:
	if RunState.TotalTroops <= 0:
		return

	# Build list of troop types currently in the army
	var Tiers = []
	for TroopName in RunState.ArmyRoster.keys():
		var Count = RunState.ArmyRoster[TroopName]
		if Count > 0:
			var Upkeep = GameConfig.Troops[TroopName].Upkeep
			Tiers.append({"Name": TroopName, "Upkeep": Upkeep, "Count": Count})

	if Tiers.is_empty():
		return

	# Sort descending by upkeep (most expensive first)
	Tiers.sort_custom(func(a, b): return a["Upkeep"] > b["Upkeep"])

	var TierCount = Tiers.size()

	# Wave cap: never kill more than this many troops in one call
	var MaxKills = int(floor(RunState.TotalTroops * GameConfig.StarvationWaveCapPercent))
	MaxKills = max(MaxKills, GameConfig.StarvationMinimumKill)

	# Prefix capacity: total food value of every tier cheaper than index i
	var CheaperCapacity = []
	CheaperCapacity.resize(TierCount)
	CheaperCapacity[TierCount - 1] = 0.0
	for i in range(TierCount - 2, -1, -1):
		CheaperCapacity[i] = CheaperCapacity[i + 1] + (Tiers[i + 1]["Upkeep"] * Tiers[i + 1]["Count"])

	var RemainingShortfall = shortfall
	var RemainingBudget = MaxKills
	var KillPlan = {}

	var i = 0
	while i < TierCount and RemainingShortfall > 0 and RemainingBudget > 0:
		var Tier = Tiers[i]

		if CheaperCapacity[i] >= RemainingShortfall:
			# Everything cheaper than this tier can cover the rest alone — leave this tier alone
			i += 1
			continue

		# This tier is unavoidable — kill just enough of it to bring the deficit
		# down to what the cheaper tiers can finish off
		var NeedValue = RemainingShortfall - CheaperCapacity[i]
		var NeedCount = int(ceil(NeedValue / Tier["Upkeep"]))
		NeedCount = min(NeedCount, Tier["Count"])
		NeedCount = min(NeedCount, RemainingBudget)

		if NeedCount > 0:
			KillPlan[Tier["Name"]] = NeedCount
			RemainingShortfall -= NeedCount * Tier["Upkeep"]
			RemainingBudget -= NeedCount

		i += 1

	# Safety net: if rounding/edge cases produced zero kills despite a real deficit, force one
	var TotalPlanned = 0
	for c in KillPlan.values():
		TotalPlanned += c
	if TotalPlanned == 0 and shortfall > 0:
		var Cheapest = Tiers[TierCount - 1]
		KillPlan[Cheapest["Name"]] = min(GameConfig.StarvationMinimumKill, Cheapest["Count"])

	# Execute
	for TroopName in KillPlan.keys():
		var Count = KillPlan[TroopName]
		if Count > 0:
			ModifyArmy(TroopName, -Count)
			EventBus.TroopStarved.emit(TroopName, Count, true) 
			print("Starved")
