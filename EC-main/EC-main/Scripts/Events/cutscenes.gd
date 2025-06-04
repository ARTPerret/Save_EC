extends Node2D

@export var timeline: String

@onready var cut_anim: AnimationPlayer = $AnimationPlayer

var player: Player

func _ready() -> void:
	EventBus.add_signal("play_cutscene", cutscene_play)

func cutscene_play(anim_name: String = ""):
	if anim_name:
		EventBus.emit_signal("in_game_event_active", true)
		cut_anim.play(anim_name)
	else:
		cut_anim.play()

func cutscene_dialogue(time_cut: String, book_id: int) -> void:
	cut_anim.pause()
	Dialogic.start(time_cut, "book" + str(book_id))

func play_audio(sfx: AudioStreamWAV, volume: float) -> void:
	AudioManager.play_sfx(sfx, volume)

func cutscene_end(_anim_name: StringName) -> void:
	EventBus.emit_signal("in_game_event_active", false)
	Dialogic.emit_signal("timeline_ended")

func move_player(target: Vector2) -> void:
	player.set_movement_target(target)

func change_player_state(anim: String):
	player.state_machine.change_state(anim)

func cutscene_fade(target: float, duration: float) -> void:
	FadeManager.trigger_fade(target,duration)
