extends Control

@export var start_heure: int
@export var start_minute: int
@export var start_seconde: int
@export var start_time_multi: float = 1.0
@export_group("Setup")

@export var carbone_element: Control
@export var follower_element: Control

var time: float
var heure: int
var minute: int
var seconde: int
var time_multi: float
var format_string = "%02d : %02d : %02d"
var tween: Tween
var is_tweening: bool

@onready var timer_bar: ProgressBar = $Bars/TimeBar
@onready var changing_timer_bar: ProgressBar = $Bars/TimeBar/ChangeTimeBar
@onready var time_label = $Labels/Time
@onready var time_multi_label = $Labels/TimerBarIndicateur

func _ready() -> void:
	initialize_timer()
	_initialize_signals()

func initialize_timer() -> void:
	pause_time(true)
	if SaveManager.getElement("Stats", "heure") != null:
		heure = SaveManager.getElement("Stats", "heure")
		minute = SaveManager.getElement("Stats", "minute")
		seconde = SaveManager.getElement("Stats", "seconde")
		time_multi =SaveManager.getElement("Stats", "time_multi")
		time_label.text = format_string % [heure, minute, seconde]
		time = (heure * 3600) + (minute * 60) + seconde # Calcul du temps initial en secs
	else:
		heure = start_heure
		minute = start_minute
		seconde = start_seconde
		time_multi = start_time_multi
		time_label.text = format_string % [heure, minute, seconde] # Affiche le temps en format HH : MM : SS
		time = (heure * 3600) + (minute * 60) + seconde # Calcul du temps initial en secs

func _initialize_signals() -> void:
	EventBus.add_signal("save_time", save_time)
	EventBus.add_signal("pause_time", pause_time)
	EventBus.add_signal("change_time", change_time)
	EventBus.add_signal("reset_time", initialize_timer)
	EventBus.add_signal("update_music", update_music)

func _process(delta: float) -> void:
	if time > 0:
		time -= delta * time_multi
		heure = int(time / 3600)
		minute = int(time / 60) % 60
		seconde = int(time) % 60
		time_label.text = format_string % [heure, minute, seconde]
		
		if not is_tweening:
			timer_bar.value = -time
	else:
		time_label.text = format_string % [0, 0, 0]
		pause_time(true)
		if Dialogic.current_timeline:
			await Dialogic.timeline_ended
		Dialogic.start("debug_game_over")

func update_grading(upd_music: bool = false) -> void:
	var grading_score: float = carbone_element.empreinte - floor(follower_element.follower/4)
	match grading_score:
		var x when x >= 18:
			time_multi = 1.5
			time_multi_label.text = ">>>>>"
		var x when x < 18 and x >= 15:
			time_multi = 1.5
			time_multi_label.text = ">>>>>"
		var x when x < 15 and x >= 12:
			time_multi = 1.2
			time_multi_label.text = ">>>>"
		var x when x < 12 and x >= 9:
			time_multi = 1
			time_multi_label.text = ">>>"
		var x when x < 9 and x >= 6:
			time_multi = 0.8571
			time_multi_label.text = ">>"
		var x when x < 6 and x > 2 :
			time_multi = 0.75
			time_multi_label.text = ">"
		var x when x <= 2:
			time_multi =  0.75
			time_multi_label.text = ">"
	
	if upd_music:
		update_music()

func update_music() -> void:
	if time_multi < 1:
		AudioManager.set_channel_volume(0,0)
		AudioManager.set_channel_volume(1,-60)
		AudioManager.set_channel_volume(2,-60)
	elif time_multi == 1:
		AudioManager.set_channel_volume(0,-60)
		AudioManager.set_channel_volume(1,0)
		AudioManager.set_channel_volume(2,-60)
	elif time_multi > 1:
		AudioManager.set_channel_volume(0,-60)
		AudioManager.set_channel_volume(1,-60)
		AudioManager.set_channel_volume(2,0)
		

func save_time() -> void:
	SaveManager.setElement("Stats", {"heure": heure})
	SaveManager.setElement("Stats", {"minute": minute})
	SaveManager.setElement("Stats", {"seconde": seconde})
	SaveManager.setElement("Stats", {"time_multi": time_multi})

func pause_time(is_paused: bool) -> void:
	set_process(!is_paused)

func change_time(var_time: float) -> void:
	is_tweening = true
	time += var_time
	
	if var_time < 0:
		changing_timer_bar.visible = true
		changing_timer_bar.value = -time
	
	# Animation de la bar de temps / thermomètre
	tween = create_tween()
	tween.connect("finished", tween.kill)
	tween.tween_property(timer_bar, "value", -time, 0.5)
	
	await tween.finished
	
	is_tweening = false
	changing_timer_bar.visible = false

func reset_time() -> void:
	time_label.text = format_string % [start_heure, start_minute, start_seconde] # Affiche le temps en format HH : MM : SS
	time = (start_heure * 3600) + (start_minute * 60) + start_seconde # Calcul du temps initial en secs

func _on_button_pressed() -> void:
	change_time(1000.0)
