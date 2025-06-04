extends Node2D

@export var tele_node: Node2D

func _physics_process(_delta: float) -> void:
	if tele_node.is_off == true:
		tele_node.sprite.play("off")
		queue_free()

func initialize_quest() -> void:
	if SaveManager.getElement("Quests", "S_television") == true:
		tele_node.sprite.play("off")
		queue_free()
