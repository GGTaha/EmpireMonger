extends Node
signal Tick
signal NewDay

#signal AddGold(amount : int)
#signal SubtractGold(amount : int)
signal GoldClicked()
signal GoldProgressed(amount : int)
signal VisualiseGoldProgress(amount : int, wraps : int)
signal GoldUpgradePressed()
signal GoldUpgraded(amount : int, success : bool)

#signal AddBread(amount : int)
#signal SubtractBread(amount : int)
signal BreadClicked()
signal BreadProgressed(amount : int)
signal VisualiseBreadProgress(amount : int, wraps : int)
signal BreadUpgradePressed()
signal BreadUpgraded(amount : int, success : bool)

signal ResourceUpdated(resource: String)

signal GarrisonUpgradePressed()
signal GarrisonUpgraded(amount : int, success : bool)
signal RecruitAttempted(TroopType : String, amount : int)
signal TroopRecruited(TroopType : String, amount : int, success : bool)
signal TroopStarved(TroopType : String, amount : int, success : bool)



signal UpdateProdHud
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
