extends Pawn
class_name Player

const SPRINT_SPEED: float = 100

var props_around: Array[Node2D]

var input_direction: Vector2
var input_interact: bool

var curr_speed: float

var in_event: bool = false
var is_talking: bool = false

func _ready() -> void:
	super()
	initialize_signals()

func initialize_signals() -> void:
	Dialogic.timeline_started.connect(onTimelineStarted)
	Dialogic.timeline_ended.connect(onTimelineEnded)
	EventBus.add_signal("in_game_event_active", set_in_event)

func allow_input() -> bool:
	return not is_talking and not in_event

func handle_input() -> void:
	input_direction = Game.inputs.get_direction()

func handle_sprint() -> void:
	if (Game.inputs.is_sprinting()):
		curr_speed = SPRINT_SPEED
	else:
		curr_speed = SPEED

func handle_interact() -> void:
	if (Game.inputs.is_interacting()):
		if (props_around):
			props_around[props_around.size()-1].on_interact(self)

#region SIGNAUX
func onTimelineStarted() -> void:
	is_talking = true

func onTimelineEnded() -> void:
	is_talking = false

func set_in_event(arg: bool) -> void:
	in_event = arg
#endregion

#region PATHFINDING
func set_movement_target(movement_target: Vector2) -> void:
	state_machine.change_state("Pathfinding")
	navigationAgent.target_position = movement_target

func _on_navigation_agent_2d_navigation_finished() -> void:
	state_machine.change_state("Regular")
#endregion
