extends PawnState

func animate(pawn: Pawn, _delta: float) -> void:
	pawn.skin.set_animation_state(PawnSkin.ANIMATION_STATES.idle)
