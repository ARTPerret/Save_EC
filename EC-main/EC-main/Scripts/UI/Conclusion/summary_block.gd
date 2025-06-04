extends VBoxContainer

@export var desciption: Control

var mouse_on_title: bool

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed and mouse_on_title:
				desciption.visible = !desciption.visible

func _on_mouse_toggle(arg: bool) -> void:
	mouse_on_title = arg

func _on_source_label_clicked(meta: Variant) -> void:
	OS.shell_open(meta)
