extends Area2D

@export var next_scene: String = "Residence_interior_haut"
@export var pos_id: int = 2
@export var loading_screen_type: String = ""

func _on_body_entered(body: Node) -> void:
	if body is Player:
		ThreadLoad.load_scene(next_scene, pos_id, loading_screen_type)
		body.in_event = true
