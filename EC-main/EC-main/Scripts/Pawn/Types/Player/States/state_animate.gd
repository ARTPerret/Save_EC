extends PawnState

@export var anim_state: int

func enter(pawn: Pawn) -> void:
	pawn.skin.set_animation_state(anim_state)

func animate(pawn: Pawn, _delta: float) -> void:
	pawn.skin.set_animation_speed(1.0)
