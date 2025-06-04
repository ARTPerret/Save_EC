extends Node2D

func _on_level_transition(body: Node2D, next_scene: String, pos_id: int = 0, loading_screen_type: String = "") -> void:
	if body is Player:
		ThreadLoad.load_scene(next_scene, pos_id, loading_screen_type)
		body.in_event = true

func _on_dialogue_level_transition(body: Node2D, dialogue: String) -> void:
	if body is Player:
		Dialogic.start(dialogue)
