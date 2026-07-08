extends Node2D
@onready var Menus = [$MineWindow, $FarmWindow]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mine_pressed() -> void:
	for menu in Menus:
		if menu != null:
			menu.hide()
	$MineWindow.show()



func _on_farm_pressed() -> void:
	for menu in Menus:
		if menu != null:
			menu.hide()
	$FarmWindow.show()


func _on_garrison_pressed() -> void:
	for menu in Menus:
		if menu != null:
			menu.hide()
	$GarrisonWindow.show()
