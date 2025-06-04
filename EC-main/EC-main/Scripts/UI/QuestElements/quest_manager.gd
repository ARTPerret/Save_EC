extends Control

@export_group("Quest Settings")
@export var quest_data: QuestList
@export var quest_prefab: PackedScene
@export_group("Font Settings")
@export var label_medium_settings: LabelSettings
@export var label_small_settings: LabelSettings
@export_group("Sound Effects")
@export var sfx_new_quest: AudioStreamWAV
@export var sfx_quest_done: AudioStreamWAV

var tween: Tween
var quest_list: Array = []

@onready var target: BoxContainer = $QuestContainer/MarginContainer/Columns/QuestList
@onready var mission_label: Label = $QuestContainer/MarginContainer/Columns/MissionName/Label
@onready var hide_button: MarginContainer = $HidePanel

func _ready() -> void:
	_initialize_signals()
	_initialize_quests()

func _initialize_signals() -> void:
	EventBus.add_signal("add_quest", add_quest)
	EventBus.add_signal("remove_quest", remove_quest)
	EventBus.add_signal("clean_quests", clean_quests)
	EventBus.add_signal("set_quest_state", set_quest_state)
	EventBus.add_signal("set_mission_name", set_mission_name)

func _initialize_quests() -> void:
	if SaveManager.getElement("Player", "curr_quests") != null:
		var quest_list_load: Array = SaveManager.getElement("Player", "curr_quests")
		
		for i in quest_list_load:
			add_quest(i)
	else:
		_save_current_quests() # Sauvegarde la liste vide pour qu'il y ai quelque chose à vérifier

func add_quest(key: String, quest_pos: int = target.get_child_count()) -> void:
	AudioManager.stop_sfx()
	AudioManager.play_sfx(sfx_new_quest, -5.0)
	
	var new_quest_data: Resource = load(quest_data.quests[key])
	var new_quest: BoxContainer = quest_prefab.instantiate()
	
	var new_quest_label: Label = new_quest.get_node("Margin/Panel/Label")
	var new_quest_panel: PanelContainer = new_quest.get_node("Margin/Panel")
	var new_quest_margin: MarginContainer = new_quest.get_node("Margin")
	
	match (new_quest_data.type): # Ajoute un style différent en fonction du type de quête
		# Note : À refaire au propre à un moment--on a eu le temps de s'améliorer entre temps ! - Emilien
		0:
			new_quest_label.label_settings = label_medium_settings
			
			new_quest_margin.add_theme_constant_override("margin_left", 10)
		1:
			new_quest_margin.add_theme_constant_override("margin_left", 25)
			new_quest_margin.add_theme_constant_override("margin_right", 10)
			new_quest_label.label_settings = label_small_settings
			new_quest_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
			new_quest_panel.self_modulate = 0
	
	new_quest_label.text = new_quest_data.name
	new_quest.name = key
	
	if SaveManager.getElement("Quests", key) == true:
		new_quest_label.modulate = Color.GREEN
	else:
		SaveManager.setElement("Quests", {key: false})
	
	quest_list.append(key)
	target.add_child(new_quest)
	target.move_child(target.get_child(target.get_child_count()-1), quest_pos) # Pour deplacer la quête dans une autre position
	
	_save_current_quests() 

func clean_quests() -> void:
	for i in target.get_children():
		i.queue_free()
	
	quest_list.clear()
	
	_save_current_quests() 

func remove_quest(quest_name: String) -> void:
	var quest_del: BoxContainer = target.get_node_or_null(quest_name)
	var quest_del_id: int = quest_list.find(quest_name)
	
	if quest_del:
		quest_del.queue_free()
		quest_list.remove_at(quest_del_id)

func set_quest_state(quest_name: String) -> void:
	AudioManager.stop_sfx()
	AudioManager.play_sfx(sfx_quest_done, -5.0)
	
	target.get_node(quest_name + "/AnimationPlayer").play("quest_complete")
	SaveManager.setElement("Quests", {quest_name: true})

func set_mission_name(new_name: String) -> void:
	mission_label.text = new_name

func _save_current_quests() -> void:
	SaveManager.setElement("Player", {"curr_quests": quest_list})

func _on_texture_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		position.x = position.x + ( size.x - hide_button.size.x )
	else:
		position.x = position.x - ( size.x - hide_button.size.x )
		
