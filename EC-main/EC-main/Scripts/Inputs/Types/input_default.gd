extends InputManager

const INTERACT_COOLDOWN: float = 0.4

var interact_cooldown: float

var is_toggle_sprinting: bool = false

func _ready() -> void:
	initialize_signals()

func initialize_signals() -> void:
	Dialogic.timeline_ended.connect(onTimelineEnded)

func _process(delta: float) -> void:
	if interact_cooldown > 0:
		interact_cooldown -= delta

func get_direction() -> Vector2:
	var horizontal: float = Input.get_axis("left", "right")
	var vertical: float = Input.get_axis("up", "down")
	return Vector2(horizontal, vertical)

func is_sprinting() -> bool:
	if toggleable_sprint:
		if Input.is_action_just_pressed("sprint"):
			is_toggle_sprinting = !is_toggle_sprinting
		
		if is_toggle_sprinting:
			return true
		else:
			return false
	
	return Input.is_action_pressed("sprint")

func is_interacting() -> bool:
	var result: bool = Input.is_action_just_pressed("interact")
	if result && interact_cooldown > 0:
		result = false
	
	return result

func onTimelineEnded() -> void:
	interact_cooldown = INTERACT_COOLDOWN
