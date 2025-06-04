extends Control

@export var sfx_follow: AudioStreamWAV
@export var time_element: Control

var follower: int = 0

@onready var follower_label: Label = $Label
@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	_initialize_signals()
	_initialize_save()
	_initialize_follower()

func _initialize_signals() -> void:
	EventBus.add_signal("reset_time", reset_follower)

func _initialize_save() -> void:
	if SaveManager.getElement("Stats", "follower"):
		follower = SaveManager.getElement("Stats", "follower")
		time_element.update_grading()

func _initialize_follower() -> void:
	follower_label.text = str(follower)
	EventBus.add_signal("add_follower", add_follower)

func add_follower(arg: int = 1) -> void:
	AudioManager.play_sfx(sfx_follow, -5.0)
	
	anim_player.play("feedback_good")
	follower += arg
	follower_label.text = str(follower)
	time_element.update_grading(true)
	time_element.change_time(180)
	SaveManager.setElement("Stats",{"follower":follower})

func reset_follower() -> void:
	follower = 0
	follower_label.text = str(follower)
	time_element.update_grading()
