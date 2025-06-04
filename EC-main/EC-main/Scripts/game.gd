extends Node2D
class_name Game

@export var first_map: String
@export var controls: Resource
@export var viewport: SubViewport

static var inputs: InputManager

func _ready() -> void:
	_initialize_signals()
	_initialize_viewport()
	_initialize_save()
	_initialize_inputs()
	_initialize_dialogic()

func _initialize_signals() -> void:
	EventBus.add_signal("set_ui_visibility", $UI/InfoElements.set_visible)
	EventBus.add_signal("set_ui_visibility", $UI/QuestElements.set_visible)
	EventBus.add_signal("set_ui_visibility", $UI/InvElements.set_visibility)

func _initialize_viewport() -> void:
	ThreadLoad.initialize_viewport(viewport)

func _initialize_save() -> void:
	if SaveManager.getElement("Player", "scene") != null:
		var load_scene: String = SaveManager.getElement("Player", "scene")
		var load_pos: int = SaveManager.getElement("Player", "pos")
		ThreadLoad.load_scene(load_scene, load_pos)
	else:
		ThreadLoad.load_scene(first_map)

func _initialize_inputs() -> void:
	match OS.get_name():
		"Web":
			if EcoUtils.is_on_mobile():
				inputs = load(controls.types["Mobile"]).instantiate()
			else:
				inputs = load(controls.types["Default"]).instantiate()
		_: # Si pas sur plateforme web
			inputs = load(controls.types["Default"]).instantiate()
	
	$UI.add_child(inputs)

func _initialize_dialogic() -> void:
	Dialogic.start("init")
