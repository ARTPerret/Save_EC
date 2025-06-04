extends CharacterBody2D
class_name Pawn

const SPEED: float = 50

@onready var skin: PawnSkin = $Skin
@onready var state_machine: StateMachine = $StateMachine
@onready var navigationAgent: NavigationAgent2D = $NavigationAgent2D
@onready var navigationObs: NavigationObstacle2D = $NavigationObstacle2D

func _ready() -> void:
	initialize_state_machine()
	initialize_pawn()

func initialize_state_machine() -> void:
	state_machine.initialize()

func _physics_process(delta):
	handle_state_update(delta)
	handle_state_animation(delta)

func initialize_pawn():
	pass

func handle_state_update(delta: float) -> void:
	state_machine.update_state(delta)

func handle_state_animation(delta) -> void:
	state_machine.animate_state(delta)

func set_movement_target(_movement_target: Vector2):
	pass

func _on_navigation_agent_2d_navigation_finished() -> void:
	pass

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	move_and_slide()
