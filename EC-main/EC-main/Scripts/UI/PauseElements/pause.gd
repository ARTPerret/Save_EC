extends Node2D

var in_event: bool = false

func _ready() -> void:
	EventBus.add_signal("in_game_event_active", set_in_event)

func _process(_delta: float) -> void:
	if (Input.is_action_just_pressed("pause")):
		if !Dialogic.current_timeline and not in_event:
			EventBus.emit_signal("set_pause")

func set_in_event(arg: bool):
	in_event = arg
