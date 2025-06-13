extends PropTalk

@export var sfx_pick_up: AudioStreamWAV
@export var give_item: String

@onready var id: int = get_index()

func initialize_garbage() -> void:
	var dechet_data: Array = SaveManager.getElement("Missions", "Dechet_Haut")
	if dechet_data[id] == true:
		queue_free()

func on_interact(player: Player) -> void:
	if SaveManager.getElement("Quests", "Q_antoine") == null: # Quête inactive (pas de sauvegarde)
		super(player)
		await Dialogic.timeline_ended
		SaveManager.setElement("Quests", {"Q_antoine": false})
	
	AudioManager.play_sfx(sfx_pick_up, -5.0)
	EventBus.emit_signal("add_item", give_item)
	
	var dechet_data: Array = SaveManager.getElement("Missions", "Dechet_Haut")
	dechet_data[id] = true
	SaveManager.setElement("Missions", {"Dechet_Haut": dechet_data})
	
	visible = false
	
	if not dechet_data.has(false):
		if SaveManager.getElement("Quests", "S_dechet_campus") == "bas":
			SaveManager.setElement("Quests", {"S_dechet_campus": "all"})
			Dialogic.start("prop_trash", "book2")
			await Dialogic.timeline_ended
			SaveManager.save()
		else:
			SaveManager.setElement("Quests", {"S_dechet_campus": "haut"})
			Dialogic.start("prop_trash", "book3")
			await Dialogic.timeline_ended
			SaveManager.save()
	
	queue_free()
