extends Node2D

func _ready() -> void:
	if SaveManager.getElement("Missions", "Dechet_Bas") == null: # Si il y a aucune sauvegarde
		var dechet_data: Array
		
		for i in get_children().size():
			dechet_data.append(false)
			
		SaveManager.setElement("Missions", {"Dechet_Bas": dechet_data})
	else:
		for child in get_children():
			child.initialize_garbage()
