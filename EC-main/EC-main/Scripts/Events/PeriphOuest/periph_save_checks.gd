extends Node2D

@export var timeline: String

func initialize() -> void:
	if SaveManager.getElement("Events", timeline) == null:
		SaveManager.setElement("Events", {timeline: false})
		Dialogic.start(timeline)
	
	$MissionEboueur.check_mission_done()
	$PlayerCarCheck.check_state()
	$MissionVelo.check_mission_done()
