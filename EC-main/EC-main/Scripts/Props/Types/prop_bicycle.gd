extends PropTalk

func on_interact(player: Player) -> void:
	super(player)

func exists(arg: bool) -> void:
	visible = arg
	$Area2D/CollisionShape2D.disabled = !arg
	$StaticBody2D/CollisionShape2D.disabled = !arg
