extends Node

@export var timeline: String

func initialize() -> void:
	if SaveManager.getElement("Events", timeline) == null:
		SaveManager.setElement("Events", {timeline: false})
		Dialogic.start(timeline)
	
	if SaveManager.getElement("Quests", "0-1_deplacer") == true:
		# Supprime la mission si elle est déjà accomplie
		$MissionMoveCheck.queue_free()
	else:
		$MissionMoveCheck.initialize_quest(get_parent().player)
		
	if SaveManager.getElement("Quests", "0-2_chaise") == true:
		$MissionChairCheck.queue_free()
	
	$MissionTeleCheck.initialize_quest()
