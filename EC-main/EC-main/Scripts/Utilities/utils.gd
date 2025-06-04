extends Object
class_name EcoUtils

static func is_on_mobile() -> bool:
	return OS.has_feature("web_android") || OS.has_feature("web_ios")
