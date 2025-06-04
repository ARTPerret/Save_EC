extends Control

@export var time_element: Control
@export var sfx_good_score: AudioStreamWAV
@export var sfx_bad_score: AudioStreamWAV

var empreinte: float = 10

@onready var empreinte_label: Label = $Label
@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	_initialize_signals()
	_initialize_save()
	_initialize_empreinte()

func _initialize_signals() -> void:
	EventBus.add_signal("reset_time", reset_score)

func _initialize_save() -> void:
	if SaveManager.getElement("Stats", "score"):
		empreinte = SaveManager.getElement("Stats", "score")
		time_element.update_grading()

func _initialize_empreinte() -> void:
	empreinte_label.text = str(empreinte)
	EventBus.add_signal("set_empreinte", on_update_empreinte)

func on_update_empreinte(arg: float) -> void:
	play_feedback(arg)
	empreinte += arg  * 2 # LE "* 2" EST POUR LES BESOINS DE LA VERTICAL SLICE- À RETIRER DANS LA VERSION FINALE !!!
	empreinte_label.text = str(empreinte)
	time_element.update_grading(true)
	SaveManager.setElement("Stats",{"score":empreinte})

func play_feedback(score: float) -> void:
	if score > 0:
		AudioManager.play_sfx(sfx_bad_score, -5.0)
		anim_player.play("feedback_bad")
	else:
		AudioManager.play_sfx(sfx_good_score, -5.0)
		anim_player.play("feedback_good")

func reset_score() -> void:
	empreinte = 10
	empreinte_label.text = str(empreinte)
	time_element.update_grading()
