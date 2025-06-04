extends Prop

@export var sfx_door: AudioStreamWAV

var toggle_state: bool = false
var can_open: bool = true
var is_inside: bool = false

@onready var collider_box: CollisionShape2D = $StaticBody2D/CollisionShape2D

func on_interact(_player: Player) -> void:
	if can_open and !is_inside:
		AudioManager.play_sfx(sfx_door, -10.0)
		
		if !toggle_state:
			sprite.play("close_open")
			toggle_state = true
			can_open = false
			collider_box.disabled = true
		else:
			sprite.play("open_close")
			toggle_state = false
			can_open = false
			collider_box.disabled = false

func _on_prop_sprite_animation_finished() -> void:
	can_open = true

func _check_collision_enter(body: Node2D) -> void:
	# Si le joueur entre dans le StaticBody2D de la porte
	if body is Player:
		is_inside = true

func _check_collision_exit(body: Node2D) -> void:
	# Si le joueur sort du StaticBody2D de la porte
	if body is Player:
		is_inside = false
