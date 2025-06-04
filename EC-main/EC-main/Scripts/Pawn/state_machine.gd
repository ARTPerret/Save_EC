extends Node2D
class_name StateMachine

@export var initial_state: String = "Regular"

@onready var pawn: Pawn = get_parent()

var states: Dictionary[String, Node2D]
var current_state: String
var last_state: String

func initialize() -> void:
	initialize_states()
	change_state(initial_state)

func initialize_states() -> void:
	for i in get_children():
		states[i.name] = i

func change_state(to: String) -> void:
	if current_state:
		states[current_state].exit(pawn)
	
	last_state = current_state
	current_state = to
	states[current_state].enter(pawn)

func update_state(delta: float) -> void:
	if current_state:
		states[current_state].step(pawn, delta)

func animate_state(delta: float) -> void:
	if current_state:
		states[current_state].animate(pawn, delta)
