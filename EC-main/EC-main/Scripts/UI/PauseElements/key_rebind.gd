extends PanelContainer

@onready var label : Label = $HBoxContainer/Label
@onready var button : Button = $HBoxContainer/ButtonPanel/Button
 
var binds : Array 

@export var action_name : String = "left"

var inputlist: Dictionary [String, String] = {
	"left" : "Gauche",
	"right" : "Droite",
	"up" : "Haut",
	"down" : "Bas",
	"interact" : "Interagir",
} 

func _ready():
	set_process_unhandled_key_input(false)
	set_action_name()
	set_text_for_key()

func set_action_name() -> void:
	if action_name:
		label.text = inputlist[action_name]
	else:
		label.text = "Non assigné"


func set_text_for_key() -> void:
	var action_events = InputMap.action_get_events(action_name)
	var action_event = action_events[0]
	var action_keycode = OS.get_keycode_string(action_event.physical_keycode)

	button.text = "%s" % action_keycode


func _on_button_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		button.text = "(...)"
		set_process_unhandled_key_input(toggled_on)
		
		for i in get_parent().get_children():
			if i.action_name != self.action_name:
				i.button.toggle_mode = false
				i.set_process_unhandled_input(false)
	
	else:
		for i in get_parent().get_children():
			if i.action_name != self.action_name:
				i.button.toggle_mode = true
				i.set_process_unhandled_input(false)
			
		set_text_for_key()

func _unhandled_key_input(event: InputEvent) -> void:
	rebind_action_key(event)
	button.button_pressed = false

func rebind_action_key(event) -> void:
	binds = InputMap.action_get_events(action_name)
	var dupes: bool = false
	for i in binds:
		if i.as_text_physical_keycode() == event.as_text_physical_keycode():
			dupes = true
			set_process_unhandled_key_input(false)
	
	if !dupes:
		InputMap.action_erase_events(action_name)
		InputMap.action_add_event(action_name, event)
		set_process_unhandled_key_input(false)
		set_text_for_key()
