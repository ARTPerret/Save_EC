extends Node2D

func _ready() -> void:
	if SaveManager.getElement("Missions", "Plante_Park") == null: # Si il y a aucune sauvegarde
		var plant_data: Array
		
		for i in get_children().size():
			plant_data.append(false)
			
		SaveManager.setElement("Missions", {"Plante_Park": plant_data})
	else:
		for child in get_children():
			child.initialize_plant()
