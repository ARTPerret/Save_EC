extends Node2D

@export var timeline: String

func initialize() -> void:
	if SaveManager.getElement("Events", timeline) == null:
		
		EventBus.emit_signal("pause_time", true)
		
		#Synchronisation entre Var Dialogic et ce qui est dans SaveManager
		#Redondant en soit, mais évite les potentiels lag spikes pendant les Dialogues
		
		Dialogic.VAR.PetitDej = SaveManager.getElement("Choice", "PetitDej")
		Dialogic.VAR.PetitDejB = SaveManager.getElement("Choice", "PetitDejB")
		Dialogic.VAR.Lavage = SaveManager.getElement("Choice", "Lavage")
		Dialogic.VAR.Transport = SaveManager.getElement("Choice", "Transport")
		#évite que Dialogic ne râle si la quête a été ignorée
		if SaveManager.getElement("Points", "S_television") != null:
			Dialogic.VAR.Television = SaveManager.getElement("Points", "S_television")
		
		SaveManager.setElement("Events", {timeline: false})
		Dialogic.start(timeline)
