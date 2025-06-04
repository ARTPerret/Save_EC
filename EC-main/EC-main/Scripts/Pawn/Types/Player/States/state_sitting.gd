extends PawnState

func enter(pawn: Pawn) -> void:
	pawn.skin.set_animation_state(PawnSkin.ANIMATION_STATES.sit)

func step(pawn: Pawn, _delta: float) -> void:
	if pawn.allow_input():
		pawn.handle_interact()

func animate(pawn: Pawn, _delta: float) -> void:
	pawn.skin.set_animation_speed(1.0)
