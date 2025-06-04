extends Node2D

@export var velo_object: Node2D

func _physics_process(_delta: float) -> void:
	if SaveManager.getElement("Quests", "S_vélo2") == true:
		velo_object.exists(true)
		queue_free()

func check_mission_done() -> void:
	if SaveManager.getElement("Quests", "S_vélo2") == true:
		velo_object.exists(true)
		queue_free()
	else:
		velo_object.exists(false)
