extends Node2D

func _ready() -> void:
	if SaveManager.getElement("Missions", "Poubelle_Plage") == null: # Si il y a aucune sauvegarde
		var poubelle_data: Array
		
		for i in get_children().size():
			poubelle_data.append(false)
		
		SaveManager.setElement("Missions", {"Poubelle_Plage": poubelle_data})
	else:
		for child in get_children():
			child.initialize_garbage()
