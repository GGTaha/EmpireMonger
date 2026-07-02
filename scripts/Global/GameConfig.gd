extends Node
@export var TickDuration = 100 #ms
@export var DayDuration = 4 #ticks
@export var GoldClickAmount = 160 #% of progress


class GoldMine:
	
	const BaseCost = 10 #Gold
	const BasePayout = 1#Gold
	const Automatic = false
	const BaseSpeed = 1 #% of progress
	
	static func isAutomatic(level : int) -> bool:
		if level == 0:
			return false
		return true
	
	static func getUpgradeCost(level : int) -> int:
		var cost = BaseCost
		if level <= 10:
			cost = int(BaseCost**(1+0.05*level))
		else:
			cost = int(BaseCost**(1+0.01*level))
		return cost

	static func getProductionSpeed(level : int) -> int:
		var speed = BaseSpeed
		speed = BaseSpeed * ((level / 5) + 1)
		return speed
		
	static func getPayout(level : int) -> int:
		var payout = BasePayout
		payout = level + 1
		return payout






func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass
