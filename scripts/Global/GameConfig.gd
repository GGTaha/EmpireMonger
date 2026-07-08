extends Node
@export var TickDuration = 100 #ms
@export var DayDuration = 20 #ticks
@export var GoldClickAmount = 30 #% of progress
@export var BreadClickAmount = 10 #% of progress
@export var StarvationWaveCapPercent = 15 #% of starving army
@export var StarvationMinimumKill = 1



@export var TroopFiles : Array[TroopData] = [
	preload("res://scripts/data/spearman.tres"),
	preload("res://scripts/data/archer.tres")]
	
#Structure : {"Spearman" : Resource}
var Troops : Dictionary = {}

func _ready() -> void:
	for Troop in TroopFiles:
		Troops[Troop.TroopName] = Troop
	print(Troops)

class GoldMine:
	
	const BaseGoldCost = 5 #Gold
	const BasePayout = 1 #Gold
	const Automatic = false
	const BaseSpeed = 1 #% of progress
	
	static func isAutomatic(level : int) -> bool:
		if level == 0:
			return false
		return true
	
	static func getUpgradeCost(level : int) -> Dictionary:
		var Gold = BaseGoldCost
		if level <= 10:
			Gold = int(BaseGoldCost**(1+0.05*level))
		else:
			Gold = int(BaseGoldCost**(1+0.01*level))
		return {"Gold" : Gold}

	static func getProductionSpeed(level : int) -> int:
		var speed = BaseSpeed
		speed = BaseSpeed * ((level / 5) + 1)
		return speed
		
	static func getPayout(level : int) -> int:
		var payout = BasePayout
		payout = level + 1
		return payout

class BreadFarm:
	
	const BaseGoldCost = 10 #Bread
	const BasePayout = 1#Bread
	const Automatic = false
	const BaseSpeed = 1 #% of progress
	
	static func isAutomatic(level : int) -> bool:
		if level == 0:
			return false
		return true
	
	static func getUpgradeCost(level : int) -> Dictionary:
		var Gold = BaseGoldCost
		if level <= 10:
			Gold = int(BaseGoldCost**(1+0.05*level))
		else:
			Gold = int(BaseGoldCost**(1+0.01*level))
		return {"Gold" : Gold}

	static func getProductionSpeed(level : int) -> int:
		var speed = BaseSpeed
		speed = BaseSpeed * ((level / 5) + 1)
		return speed
		
	static func getPayout(level : int) -> int:
		var payout = BasePayout
		payout = level + 1
		return payout

class Garrison:
	static func getUpgradeCost(level : int) -> Dictionary:
		var Gold : int = 1000000
		if level == 0:
			Gold = 100
			return {"Gold" : Gold}
		if level == 1:
			Gold = 500
			return {"Gold" : 500}
		return {"Gold" : Gold}
