extends Node2D

@export var timeline: String

func initialize() -> void:
	if SaveManager.getElement("Events", timeline) == null:
		SaveManager.setElement("Events", {timeline: false})
		Dialogic.start(timeline)
	
	$PlayerCarCheck.check_state()
