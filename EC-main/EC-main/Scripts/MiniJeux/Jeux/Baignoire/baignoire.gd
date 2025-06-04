extends Control

@export var sfx_valve: AudioStreamWAV
@export var pos_bouch: Node2D
@export var pos_debouch: Node2D

var is_bath_mode: bool = false

@onready var animated_sprite = $SpriteBaignoire
@onready var bouchon_button = $BouchonElements/Bouchon
@onready var valve_button = $SpriteBaignoire/ValveDroite
@onready var timer = $Timer
@onready var progress_bar: ProgressBar = $ProgressBar

func shower_start() -> void:
	bouchon_button.mouse_filter = MOUSE_FILTER_IGNORE
	if is_bath_mode:
		progress_bar.max_value = 9
		bouchon_button.visible = false
		valve_button.visible = false
		animated_sprite.play("bath_start")
	else:
		animated_sprite.play("shower_start")
	
	await animated_sprite.animation_finished
	
	if is_bath_mode:
		animated_sprite.play("bath")
	else:
		animated_sprite.play("shower")
	
	timer.start()

func shower():
	progress_bar.value -= 1
	
	if is_bath_mode:
		if progress_bar.value <= 0:
			# Placez le signal de sauvegarde ici
			EventBus.emit_signal("set_quest_state", "1-2_shower")
			shower_end()
	else:
		if progress_bar.value <= 18 and progress_bar.value >= 12:
			# Placez le signal de sauvegarde ici
			if progress_bar.value == 12:
				EventBus.emit_signal("set_empreinte", -0.2)
				SaveManager.setElement("Points", {"1-2_shower": -0.2})
				EventBus.emit_signal("set_quest_state", "1-2_shower")
		elif progress_bar.value < 12 and progress_bar.value >= 6:
			if progress_bar.value == 6:
				EventBus.emit_signal("set_empreinte", 0.1)
		elif progress_bar.value == 0:
			EventBus.emit_signal("set_empreinte", 0.1)
			shower_end()
			return
		
		valve_button.disabled = false

func shower_end() -> void: # Vide la baignoire puis finis le mini jeu -> valide le score
	valve_button.visible = false
	timer.stop()
	
	if is_bath_mode:
		SaveManager.setElement("Choice", {"Lavage": 2}) #sauvegarde du choix pour Dialogic
		animated_sprite.play("bath_end")
	else:
		SaveManager.setElement("Choice", {"Lavage": 1}) #sauvegarde du choix pour Dialogic
		animated_sprite.play("shower_end")
	
	await get_tree().create_timer(2.0).timeout
	get_parent().quit_minigame()

func shower_stop(): # Pause la douche avant que le joueur ne soit lavé. Si lavé, appel shower_end
	if progress_bar.value <= 12:
		shower_end()
		return
	
	timer.stop()
	animated_sprite.play("shower_end")
	await animated_sprite.animation_finished
	valve_button.disabled = false

func _on_button_pressed() -> void:
	AudioManager.play_sfx(sfx_valve)
	
	valve_button.disabled = true
	if timer.is_stopped():
		shower_start()
	else:
		shower_stop()

func _on_bouchon_pressed(toggled_on: bool) -> void:
	AudioManager.play_sfx(sfx_valve)
	is_bath_mode = toggled_on
	
	if toggled_on:
		bouchon_button.position = pos_bouch.position
	else:
		bouchon_button.position = pos_debouch.position
