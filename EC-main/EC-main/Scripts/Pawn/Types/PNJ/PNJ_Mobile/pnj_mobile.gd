extends PNJ
class_name PNJMobile

@export var path_size: int

var manager: Node2D
var target_id: int = 0
var spawn_point: Vector2
var targets: Array[Vector2]
var skin_texture: Texture2D
var dial_id: int = 1

func _ready() -> void:
	super()
	initialize_skin()

func initialize_skin() -> void:
	skin.texture = skin_texture

func initialize_pawn() -> void:
	await get_tree().physics_frame
	randomize()
	
	# Pour le chemin du PNJ
	while targets.size() < path_size - 1:
		var rng_middle_target: int = randi_range(0, manager.path_target_array.size() - 1)
		var path_point: Vector2 = manager.path_target_array[rng_middle_target]
		
		if not targets.has(path_point):
			targets.append(path_point)
	
	# Pour le point de fin du PNJ
	while targets.size() < path_size:
		var rng_end_target: int = randi_range(0, manager.spawn_target_array.size() - 1)
		var end_point: Vector2 = manager.spawn_target_array[rng_end_target]
		
		if spawn_point != end_point:
			targets.append(end_point)
	
	set_movement_target(targets[target_id])

func on_interact(player: Player) -> void:
	erase_outline()
	state_machine.change_state("Regular")
	Dialogic.start(timeline, "book" + str(dial_id))
	
	await Dialogic.timeline_started
	
	var play_dir: Vector2 = position - player.position
	player.skin.set_animation_direction(play_dir)
	skin.set_animation_direction(-play_dir)
	
	await Dialogic.timeline_ended
	state_machine.change_state("Pathfinding")

func _on_navigation_agent_2d_navigation_finished() -> void:
	target_id += 1
	if target_id >= targets.size():
		queue_free()
		manager.initialize_pnj()
	else:
		set_movement_target(targets[target_id])
