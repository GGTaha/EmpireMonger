extends Resource
class_name TroopData

@export var TroopName : String
@export var TroopDescription : String
@export var Upkeep : int # Per Month
@export var GarrisonLevel : int = 1
@export var Cost : Dictionary = {"Gold": 0, "Bread": 0}
@export var icon : Texture2D
@export var LevelData : Array[TroopLevelData]
