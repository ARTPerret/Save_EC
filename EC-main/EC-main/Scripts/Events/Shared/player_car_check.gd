extends Node2D

@export var current_location: String
@export var car_object: Node2D

func check_state() -> void:
	if SaveManager.getElement("Misc", "Car") == null:
		SaveManager.setElement("Misc", {"Car": "PeriphOuest"})
	else:
		if not SaveManager.getElement("Misc", "Car") == current_location:
			car_object.queue_free()
