extends PropTalk

@export var sfx_pick_up: AudioStreamWAV
@export var give_item: String

@onready var id: int = get_index()

func initialize_garbage() -> void:
	var poubelle_data: Array = SaveManager.getElement("Missions", "Poubelle_Plage")
	if poubelle_data[id] == true:
		queue_free()

func on_interact(player: Player) -> void:
	if SaveManager.getElement("Quests", "S_plage") == null: # Quête inactive (pas de sauvegarde)
		super(player)
		await Dialogic.timeline_ended
		SaveManager.setElement("Quests", {"S_plage": false})
	
	AudioManager.play_sfx(sfx_pick_up, -5.0)
	EventBus.emit_signal("add_item", give_item)
	
	var poubelle_data: Array = SaveManager.getElement("Missions", "Poubelle_Plage")
	poubelle_data[id] = true
	SaveManager.setElement("Missions", {"Poubelle_Plage": poubelle_data})
	
	visible = false
	
	if not poubelle_data.has(false):
		SaveManager.setElement("Quests", {"S_plage": true})
		SaveManager.setElement("Quests", {"S_plage2": false})
		Dialogic.start("quest_trashplage", "book2")
		await Dialogic.timeline_ended
		SaveManager.save()
	
	queue_free()
