class_name Mapset

extends Node2D


@export_group("Camera Settings")
@export var background_color: Color
@export var camera_zoom: int = 4
@export var limit_left: int = 0
@export var limit_right: int = 10000
@export var limit_top: int = 0
@export var limit_bottom: int = 10000
@export_group("Music Settings")
@export var music: AudioStreamSynchronized
@export var music_volume: float

var player: Player
var camera: Camera2D
var start_id: int = 0

@onready var player_resource: PackedScene = preload("uid://cma8bt0crjux0")
@onready var camera_resource: PackedScene = preload("uid://cfutd05my7baa")
@onready var pause_ressource: PackedScene = preload("uid://bfwcj54nwr3on")

func _ready() -> void:
	initialize_scene()
	initialize_player()
	initialize_camera()
	initialize_pause()
	initialize_save_checks()
	initialize_music()

func initialize_player() -> void:
	EventBus.emit_signal("pause_time", false)
	EventBus.emit_signal("set_ui_visibility", true)
	player = player_resource.instantiate()
	player.position = $StartPoints.get_child(start_id).position # Ordre du child important
	if get_node_or_null("Cutscenes"):
		$Cutscenes.player = player # Envoie une ref pour déplacer le joueur lors des cutscenes
	add_child(player)

func initialize_camera() -> void:
	camera = camera_resource.instantiate()
	camera.zoom = Vector2(camera_zoom,camera_zoom)
	camera.target = player
	camera.set_limits(limit_left, limit_right, limit_top, limit_bottom)
	add_child(camera)

func initialize_scene() -> void:
	RenderingServer.set_default_clear_color(background_color)
	y_sort_enabled = true
	FadeManager.trigger_fade(0, 0.25, 3)
	
func initialize_pause() -> void:
	var pause = pause_ressource.instantiate()
	add_child(pause)

func initialize_save_checks() -> void:
	if get_node_or_null("SceneSaveChecks"):
		$SceneSaveChecks.initialize()

func initialize_music() -> void:
	AudioManager.fade_music(music_volume, 0)
	AudioManager.play_music(music)
	EventBus.emit_signal("update_music")
