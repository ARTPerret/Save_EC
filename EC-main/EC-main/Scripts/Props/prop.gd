extends Node2D
class_name Prop

@warning_ignore("unused_signal") signal onInteract

@onready var sprite: Node2D = $PropSprite

func draw_outline() -> void:
	sprite.material.set_shader_parameter("width",1.0)

func erase_outline() -> void:
	sprite.material.set_shader_parameter("width",0)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		body.props_around.append(self)
		draw_outline()
	
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		body.props_around.erase(self)
		erase_outline() 

func on_interact(_player: Player) -> void:
	pass
