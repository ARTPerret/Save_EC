extends Button

const SPEED: int = 400

@export_enum("Recyclable", "Non Recyclable", "Verre") var type: int
@export var select_offset: int

var click_offset: Vector2
var mouse_is_off: bool = true
var is_inside_other: bool = false
var pen_dir: float = 1
var screen_limit: float
var curr_pos_y: float = position.y

@onready var minigame_window: Control = get_parent()
@onready var coll_area: Area2D = $PushBackArea
@onready var sprite_poubelle: TextureRect = $SpritePoubelle

func _ready() -> void:
	screen_limit = minigame_window.size.x - size.x # Taille de la fenêtre moins la taille du bouton
	curr_pos_y = position.y

func _physics_process(delta: float) -> void:
	if button_pressed:
		global_position.x = get_global_mouse_position().x - click_offset.x
	
	if is_inside_other:
		position.x += pen_dir * SPEED * delta
	
	global_position.x = clamp(global_position.x, 0 , screen_limit)

func _on_interact() -> void:
	click_offset = get_global_mouse_position() - global_position
	# Lorsque le click est enfoncé désactive la zone de détéction / relaché active la zone de détéction
	coll_area.monitoring = !button_pressed
	coll_area.set_collision_layer_value(1,!button_pressed)
	
	if button_pressed:
		# Pour que la poubelle sélectionner soit toujours au-dessus
		minigame_window.holding_trash = true
		sprite_poubelle.material.set_shader_parameter("width",0.0)
		move_to_front()
	else:
		minigame_window.holding_trash = false
		if mouse_is_off == true :
			position.y = curr_pos_y
			sprite_poubelle.material.set_shader_parameter("width",0.0)
		else:
			sprite_poubelle.material.set_shader_parameter("width",0.7)

func _on_collision_other(area: Area2D, inside: bool) -> void:
	is_inside_other = inside
	if is_inside_other:
		if coll_area.global_position.x > area.global_position.x:
			pen_dir = 1
		elif coll_area.global_position.x < area.global_position.x:
			pen_dir = -1
		else:
			area.get_parent().pen_dir = -pen_dir # Si les deux poubelles occupes la même position

func _on_trash_enter(area: Area2D) -> void:
	area.monitoring = false
	if type == area.get_parent().type:
		minigame_window.update_score(-0.05)
	else:
		minigame_window.update_score(0.1)
	area.get_parent().queue_free()

func _on_mouse_hover_toogled(arg: float) -> void:
	if !minigame_window.holding_trash:
		sprite_poubelle.material.set_shader_parameter("width",arg)
		if arg == 0.0:
			position.y = curr_pos_y
			mouse_is_off = true
		else:
			position.y = curr_pos_y - select_offset
			mouse_is_off = false
	else :
		if arg == 0.0:
			mouse_is_off = true
		else:
			mouse_is_off = false
