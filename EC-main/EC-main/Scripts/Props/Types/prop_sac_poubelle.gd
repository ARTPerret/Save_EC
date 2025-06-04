extends PropTalk

@export var sfx_pick_up: AudioStreamWAV
@export var give_item: String

@onready var id: int = get_index()

func initialize_garbage() -> void:
	var poubelle_data: Array = SaveManager.getElement("Missions", "Poubelle")
	if poubelle_data[id] == true:
		queue_free()

func on_interact(player: Player) -> void:
	if SaveManager.getElement("Quests", "3-1_ramasser") == null: # Quête inactive (pas de sauvegarde)
		super(player)
	elif SaveManager.getElement("Quests", "3-1_ramasser") == false: # Quête active
		AudioManager.play_sfx(sfx_pick_up, -5.0)
		EventBus.emit_signal("add_item", give_item)
		
		var poubelle_data: Array = SaveManager.getElement("Missions", "Poubelle")
		poubelle_data[id] = true
		SaveManager.setElement("Missions", {"Poubelle": poubelle_data})
		
		visible = false
		
		if not poubelle_data.has(false):
			Dialogic.start("pnj_eboueur", "book2")
			await Dialogic.timeline_ended
			SaveManager.save()
		
		queue_free()
