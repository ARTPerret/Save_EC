extends Prop

var as_interacted: bool = false

@export var timeline: String

func on_interact(player: Player) -> void:
	if !as_interacted:
		Dialogic.start(timeline, "book1")
		as_interacted = true;
	else:
		Dialogic.start(timeline, "book2")
	
	await Dialogic.timeline_started
	
	# Modifie la direction du joueur pour faire face au PNJ
	var direction: Vector2 = position - player.position
	player.skin.set_animation_direction(direction)
