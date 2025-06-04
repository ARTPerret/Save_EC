extends Prop

var is_siting: bool = false

@export var enter_offset: Vector2
@export var exit_offset: Vector2
@export_enum("Left:-1", "Right:1") var sit_direction = -1

@onready var collision = $Collision/CollisionShape2D

func on_interact(player: Player) -> void:
	if !is_siting:
		collision.disabled = true # Désactive la collision de la chaise pour que le joueur s'assoie
		player.state_machine.change_state("Sitting")
		player.skin.set_animation_direction(Vector2i(sit_direction,0))
		player.z_index = 2
		player.position = position + enter_offset
		is_siting = true
		erase_outline() 
	else:
		collision.disabled = false
		player.state_machine.change_state("Regular")
		player.skin.set_animation_direction(Vector2i(-sit_direction,0))
		player.z_index = 0
		player.position = position + exit_offset
		is_siting = false
