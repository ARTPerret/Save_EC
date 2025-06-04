extends Area2D
@export var landing_zone: Area2D

func _on_body_entered(body):
	if body is Player:
		body.global_position = landing_zone.get_node("Marker2D").global_position
		body.in_event = true
		await get_tree().create_timer(0.3).timeout
		body.in_event = false
