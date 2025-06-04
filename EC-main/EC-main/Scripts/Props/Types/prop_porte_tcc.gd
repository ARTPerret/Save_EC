extends PropTalk

func on_interact(player: Player) -> void:
	player.visible = false
	super(player)
	await Dialogic.timeline_ended
	player.visible = true
