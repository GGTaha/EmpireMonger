extends Control





func _ready() -> void:
	EventBus.NewDay.connect(NewDay)
	EventBus.AddGold.connect(GoldChanged)
	EventBus.SubtractGold.connect(GoldChanged)

func NewDay():
	var Months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
	var total_days: int = RunState.DayNumber
	var Year: int  = total_days / 360
	var Month: int = (total_days % 360) / 30
	var Day: int   = total_days % 30
	#$".".text = str(Day) + " " + Months[Month] + ", " + str(Year) + " AE"
	$Calendar.text = Months[Month] + ", " + str(Year) + " AE"

func GoldChanged(amount):
	var Gold = RunState.Gold
	$Label.text = "Gold : " + str(Gold)
