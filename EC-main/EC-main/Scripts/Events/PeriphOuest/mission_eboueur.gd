extends Node2D

@export var eboueur: Node2D
@export var camion_eboueur: Node2D

func check_mission_done() -> void:
	if SaveManager.getElement("Quests", "3_eboueur") == true:
		eboueur.queue_free()
		camion_eboueur.queue_free()
		queue_free()
