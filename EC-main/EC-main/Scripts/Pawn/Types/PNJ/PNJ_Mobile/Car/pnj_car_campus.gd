extends PNJ
class_name PNJCar

@export var path_size: int

var manager: Node2D
var spawn_id: int
var spawn_point: Vector2
var targets: Array[Vector2]
var skin_texture: Texture2D
var target_pos: Vector2
var target_save: Vector2
var end_target_id: int
var trajet_pause: bool = false
var current_target: int = 1
var target_array: Array
var exited_spawn: bool = false
var id_in_queue:int = 0
var already_stopped:bool = false
var path: Node2D
var stop_at_parking: bool = false



@onready var animation_player = $Skin/AnimationPlayer
@onready var collision = $CollisionShape2D
@onready var detecteur = $Detecteur_Car/CollisionShape2D
@onready var collision_shape: RectangleShape2D = load("uid://dqvrvmpna3vjc")
@onready var detecteur_shape: RectangleShape2D = load("uid://bs7umie8pm1ec")

func _ready() -> void:
	super()
	initialize_skin()

func initialize_skin() -> void:
	skin.texture = skin_texture

func initialize_pawn() -> void:
	await get_tree().physics_frame
	randomize()
	
	# Pour le spawn du PNJ
	#if i.id == spawn_id:
	target_pos = target_array[current_target].position
	set_movement_target(target_pos)
	
func stop_car() -> void:
	if already_stopped == false:
		state_machine.change_state("Regular")
		stop_at_parking = true
		await get_tree().create_timer(60.0).timeout 
		stop_at_parking = false
		state_machine.change_state("Pathfinding")
		already_stopped = true

func _on_navigation_agent_2d_navigation_finished() -> void:
	current_target += 1
	if current_target >= target_array.size() - 1:
		queue_free()
		manager.path_array.append(path)
		manager.initialize_pnj()
		
	else :
		current_target += 1
		set_movement_target(target_array[current_target].position)
		visible = false
		collision.disabled = true
		detecteur.disabled = true
		position = target_array[current_target-1].position
		

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	move_and_slide()

func _on_detecteur_car_body_entered(body: Node2D) -> void:
	if body is PNJCar:
		return
	
	if body is Pawn:
		state_machine.change_state("Regular")

func _on_detecteur_car_body_exited(body: Node2D) -> void:
	if stop_at_parking == false :
		if body is PNJCar:
			return
		
		if body is Pawn:
			state_machine.change_state("Pathfinding")
