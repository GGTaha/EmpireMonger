extends Label





func _ready() -> void:
	EventBus.NewDay.connect(NewDay)

func NewDay():
	
	var total_days: int = RunState.DayNumber
	var Year: int  = total_days / 360
	var Month: int = (total_days % 360) / 30
	var Day: int   = total_days % 30
	$".".text = "Year : " + str(Year) + " Month : " + str(Month) + " Day : " + str(Day)
