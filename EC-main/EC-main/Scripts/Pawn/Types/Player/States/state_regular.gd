extends PawnState

var canMove: bool = true

func step(pawn: Pawn, _delta: float) -> void:
	if pawn.allow_input():
		pawn.handle_input()
		pawn.handle_sprint()
	
		pawn.velocity = pawn.input_direction.normalized() * pawn.curr_speed
		pawn.move_and_slide()
		
		pawn.handle_interact()

func animate(pawn: Pawn, _delta: float) -> void:
	if (pawn.allow_input() and pawn.input_direction):
		if (pawn.curr_speed == pawn.SPRINT_SPEED):
			pawn.skin.set_animation_speed(2.0)
		else:
			pawn.skin.set_animation_speed(1.0)
		
		var abs_velocity: Vector2 = abs(pawn.get_real_velocity())
		if (abs_velocity.x > 5 or abs_velocity.y > 5):
			pawn.skin.set_animation_state(PawnSkin.ANIMATION_STATES.walk)
		else:
			pawn.skin.set_animation_speed(1.0)
			pawn.skin.set_animation_state(PawnSkin.ANIMATION_STATES.idle)
			
		pawn.skin.set_animation_direction(pawn.input_direction)
	else:
		pawn.skin.set_animation_speed(1.0)
		pawn.skin.set_animation_state(PawnSkin.ANIMATION_STATES.idle)
