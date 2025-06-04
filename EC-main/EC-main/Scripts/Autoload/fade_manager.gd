extends CanvasLayer

var tween: Tween

@onready var fade: ColorRect = $ColorRect

func trigger_fade(target: float, duration: float, order: int = 1) -> void:
	fade.visible = true
	layer = order
	if tween: tween.kill()
	tween = create_tween()
	tween.tween_property(fade, "modulate:a", target, duration)
