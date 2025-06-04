extends PawnState

func enter(pawn: Pawn) -> void:
	pawn.navigationAgent.avoidance_enabled = true
	pawn.navigationObs.avoidance_enabled = false

func exit(pawn: Pawn) -> void:
	pawn.navigationAgent.avoidance_enabled = false
	pawn.navigationObs.avoidance_enabled = true

func step(pawn: Pawn, _delta: float) -> void:
	var nextPathPosition: Vector2 = to_local(pawn.navigationAgent.get_next_path_position()).normalized()
	var new_velocity = nextPathPosition * pawn.SPEED
	
	pawn.navigationAgent.set_velocity(new_velocity)

func animate(pawn: Pawn, _delta: float) -> void:
	if (pawn.get_real_velocity()):
		pawn.skin.set_animation_state(PawnSkin.ANIMATION_STATES.walk)
		pawn.skin.set_animation_direction(pawn.get_real_velocity())
	else:
		pawn.skin.set_animation_state(PawnSkin.ANIMATION_STATES.idle)
