extends Button

func _on_button_down() -> void:
	$"../Container_text".visible = !$"../Container_text".visible
