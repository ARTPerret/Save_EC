extends PropTalk

var plant_sprite_region: Rect2 = Rect2(148,58,16,17)

@onready var id: int = get_index()

func initialize_plant() -> void:
	var plant_data: Array = SaveManager.getElement("Missions", "Plante_Campus")
	if plant_data[id] == true:
		sprite.texture.region = plant_sprite_region

func on_interact(player: Player) -> void:
	var plant_data: Array = SaveManager.getElement("Missions", "Plante_Campus")
	if plant_data[id] == true:
		Dialogic.start("quest_trees", "book2")
		return
	
	if SaveManager.getElement("Quests", "Q_flora") == null: # Quête inactive (pas de sauvegarde)
		super(player)
	elif SaveManager.getElement("Quests", "Q_flora") == false: # Quête active
		Dialogic.start("quest_trees", "book3")
		await Dialogic.timeline_ended
		plant_data[id] = true
		sprite.texture.region = plant_sprite_region
		
		SaveManager.setElement("Missions", {"Plante_Campus": plant_data})
		
		if not plant_data.has(false):
			Dialogic.start("quest_trees", "book4")
			await Dialogic.timeline_ended
			SaveManager.save()
