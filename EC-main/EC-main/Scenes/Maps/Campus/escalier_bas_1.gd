extends Area2D

@export var landing_zone: Area2D
const FADE_STEPS := 3 

func _on_body_entered(body: Node) -> void:
	if body is Player:
		body.in_event = true
		FadeManager.trigger_fade(1, 0.25 , 3)
		await get_tree().create_timer(0.25).timeout
		body.global_position = landing_zone.get_node("Marker2D").global_position
		body.skin.set_animation_direction(Vector2.DOWN)
		FadeManager.trigger_fade(0, 0.25, 3)
		await get_tree().create_timer(0.25).timeout
		SaveManager.save()
		body.in_event = false
