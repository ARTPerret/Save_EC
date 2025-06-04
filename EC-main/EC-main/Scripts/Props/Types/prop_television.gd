extends PropTalk

var is_off: bool = false

func on_interact(player: Player) -> void:
	super(player)
	await Dialogic.timeline_ended
	sprite.play("off")
