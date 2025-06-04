extends Button

@export var position_item: Vector2
@export var id_piece_velo: int
@export var sfx_metal_sound: AudioStreamWAV

var click_offset: Vector2
var item_above_target: bool = false
var screen_limit: Vector2
var new_position: Vector2
var area_reference: Area2D
var minigame_window: Control

func initialize_piece() -> void:
	screen_limit = minigame_window.size - size
	global_position = position_item

func _physics_process(_delta: float) -> void:
	if button_pressed:
		global_position = get_global_mouse_position() - click_offset
	
	global_position.x = clamp(global_position.x, 0 , screen_limit.x)
	global_position.y = clamp(global_position.y, 0 , screen_limit.y)

func _on_interact() -> void:
	click_offset = get_global_mouse_position() - global_position

func _on_collision_area_area_entered(area: Area2D) -> void:
	# Vérifie si l'ancre que l'item survol est le bon
	if area.anchor_id == id_piece_velo:
		item_above_target = true
		new_position = area.global_position - (size / 2)
		area_reference = area

func _on_collision_area_area_exited(_area: Area2D) -> void:
	item_above_target = false

func _on_button_up() -> void:
	# Quand on relache la pièce,si elle est sur le bon ancre, elle s'attache, sinon elle revient à sa position d'origine
	if item_above_target:
		AudioManager.play_sfx(sfx_metal_sound)
		position_item = new_position
		self.disabled = true
		area_reference.piece_is_on = true
		minigame_window.add_action()
	global_position = position_item
