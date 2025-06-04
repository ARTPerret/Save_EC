extends PanelContainer

@export var item_display: PackedScene 
@export var list_item: Resource

var item_list: Array = []

@onready var item_column: VBoxContainer = $MarginContainer/VBoxContainer

func _ready() -> void:
	_initialize_signals()
	_initialize_inventaire()

func _initialize_signals() -> void:
	EventBus.add_signal("add_item", add_item)
	EventBus.add_signal("remove_item", remove_item)
	EventBus.add_signal("clear_items", clear_items)

func _initialize_inventaire() -> void:
	if SaveManager.getElement("Player", "inventory") != null:
		var item_list_load: Array = SaveManager.getElement("Player", "inventory")
		
		for i in item_list_load:
			add_item(i)
	else:
		_save_inventory() # Sauvegarde inventaire vide pour qu'il y ai quelque chose à vérifier
	
	visible = check_amount()

func add_item(item_name: String) -> void:
	var item_load: Control = item_display.instantiate()
	item_load.name = item_name
	item_load.get_node("MarginContainer/TextureRect").texture = load(list_item.dictionnaire[item_name])
	
	if SaveManager.getElement("Quests", "0_tutoriel") != null and SaveManager.getElement("Misc", "first_time_added") == null:
		SaveManager.setElement("Misc", {"first_time_added": true})
		if Dialogic.current_timeline:
			await Dialogic.timeline_ended
		Dialogic.start("intro_appart", "book14")
	
	item_column.add_child(item_load)
	item_list.append(item_name)
	visible = check_amount()
	
	_save_inventory()

func remove_item(item_name: String) -> void:
	var item_del: PanelContainer = item_column.get_node_or_null(item_name)
	var item_del_id: int = item_list.find(item_name)
	
	if item_del:
		item_del.queue_free()
		item_list.remove_at(item_del_id)
		visible = check_amount()

func set_visibility(_arg: bool):
	visible = false if visible else check_amount()

func check_amount() -> bool:
	if item_list.size() == 0:
		return false
	return true

func clear_items() -> void:
	for i in item_column.get_children():
		i.queue_free()
	
	item_list.clear()
	visible = false
	
	_save_inventory()

func _save_inventory() -> void:
	SaveManager.setElement("Player", {"inventory": item_list})
