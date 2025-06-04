class_name PropElevator
extends Area2D


@export var timeline: String

@export var rez_marker: NodePath
@export var etage1_marker: NodePath
@export var etage2_marker: NodePath
var in_dialogue := false 

var can_interact := false
var player: Player = null

@onready var sprite_elevator: Sprite2D = $SpriteElevator
func _ready() -> void:
	set_process_input(true)
	body_entered.connect(Callable(self, "_on_body_entered"))
	body_exited.connect(Callable(self, "_on_body_exited"))
	EventBus.add_signal("send_to_floor", Callable(self, "send_to_floor"))
	_hide_outline()

func _on_body_entered(body: Node) -> void:
	if body is Player:
		can_interact = true
		player = body
		_show_outline()

func _on_body_exited(body: Node) -> void:
	if body is Player:
		can_interact = false
		player = null
		_hide_outline()

func _input(event: InputEvent) -> void:
	if can_interact and not in_dialogue and event.is_action_pressed("ui_accept"):
		in_dialogue = true
		Dialogic.start(timeline, "book1")
		await Dialogic.timeline_started

func send_to_floor(f: int) -> void:
	var mp: NodePath = rez_marker
	if f == 1:
		mp = etage1_marker
	elif f == 2:
		mp = etage2_marker
	if player and has_node(mp):
		
		player.global_position = get_node(mp).global_position
	_hide_outline()
	in_dialogue = false

func _show_outline() -> void:
	if sprite_elevator.material:
		sprite_elevator.material.set_shader_parameter("width", 10.0)

func _hide_outline() -> void:
	if sprite_elevator.material:
		sprite_elevator.material.set_shader_parameter("width", 0.0)
