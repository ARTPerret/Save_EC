extends Node2D

@export var chair_obj: Node2D

var first_step_done: bool = false

func _physics_process(_delta: float) -> void:
	if first_step_done:
		if chair_obj.is_siting == false:
				check_mission_done()
	else:
		if chair_obj.is_siting == true:
				check_mission_done()

func check_mission_done() -> void:
	if SaveManager.getElement("Quests", "0_tutoriel") != null:
		if SaveManager.getElement("Quests", "0-2_chaise") == false:
			# Lorsque la mission est accomplie
			Dialogic.start("intro_appart", "book5")
			first_step_done = true
		else:
			# Supprime la mission si elle est déjà accomplie
			Dialogic.start("intro_appart", "book12")
			queue_free()
