extends PropTalk

var is_off: bool = false

func on_interact(player: Player) -> void:
	super(player)
	sprite.play("open")
	await Dialogic.timeline_ended
	sprite.play("close")
