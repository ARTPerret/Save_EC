@tool
extends EditorPlugin

func _build() -> bool:
	updateVersion()
	return true

func updateVersion() -> void:
	var curr_time: Dictionary = Time.get_datetime_dict_from_system()
	
	var day: String = str(curr_time.day).pad_zeros(2)
	var month: String = str(curr_time.month).pad_zeros(2)
	var year: String = str(curr_time.year).substr(2)
	var hour: String = str(curr_time.hour).pad_zeros(2)
	var version: String = "%s%s%s-%s" % [day, month, year, hour]
	
	var curr_version: String = ProjectSettings.get_setting("application/config/version")
	ProjectSettings.set_setting("application/config/version", version)
	ProjectSettings.save()
