extends Control

const ITEM_SPAWN_MARGIN: int = 50

@export var quest_comp: String
@export var items: Array[PackedScene]
@export var max_trash_items: int
@export var item_fall_speed: float
@export var sfx_trash: AudioStreamWAV

var score: float
var trash_count: int
var holding_trash: bool = false

@onready var timer = $Timer

func _ready() -> void:
	randomize()

func update_trash_count() -> void:
	AudioManager.play_sfx(sfx_trash)
	
	trash_count += 1
	if trash_count == max_trash_items:
		EventBus.emit_signal("set_empreinte", score)
		SaveManager.setElement("Points", {quest_comp: score})
		EventBus.emit_signal("remove_item", "Trash1")
		EventBus.emit_signal("remove_item", "Trash2")
		EventBus.emit_signal("remove_item", "Trash3")
		EventBus.emit_signal("remove_item", "Trash4")
		await get_tree().create_timer(2.5).timeout 
		get_parent().quit_minigame()

func update_score(value: float) -> void:
	score += value
	update_trash_count()

func _on_timer_timeout() -> void:
	if trash_count < max_trash_items:
		var trash_load = items[randi_range(0,items.size()-1)]
		var trash_instance: Node2D = trash_load.instantiate()
		
		trash_instance.speed = item_fall_speed
		
		trash_instance.position.x = randf_range(ITEM_SPAWN_MARGIN, size.x - ITEM_SPAWN_MARGIN)
		
		add_child(trash_instance)

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	timer.start()
	_on_timer_timeout()
