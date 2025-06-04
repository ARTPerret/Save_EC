extends Node2D

var audio_music: SoundMusic = SoundMusic.new("Music", 1)
var audio_sfx: SoundEffects = SoundEffects.new("SFX", 8)

func _ready() -> void:
	add_child(audio_sfx)
	add_child(audio_music)

#region SFX
func play_sfx(resource: AudioStreamWAV, volume: float = 0.0) -> void:
	audio_sfx.play(resource, volume)

func stop_sfx() -> void:
	audio_sfx.stop()
#endregion

#region Musique
func play_music(resource: AudioStreamSynchronized) -> void:
	audio_music.play(resource)

func stop_music() -> void:
	audio_music.stop()

func pause_music() -> void:
	audio_music.pause()

func resume_music() -> void:
	audio_music.resume()

func set_channel_volume(id: int, volume: float) -> void:
	audio_music.set_channel_volume(id, volume)

func fade_music(to_volume: float, duration: float) -> void:
	audio_music.fade_music(to_volume,duration)

func is_same_music(resource: AudioStreamSynchronized) -> bool:
	return audio_music.is_same_music(resource)
#endregion

#region AudioBus
func set_bus(bus_id: int ,volume_db: float) -> void:
	AudioServer.set_bus_volume_db(bus_id,volume_db)

func muting_bus(bus_id: int ,is_mute: bool) -> void:
	AudioServer.set_bus_mute(bus_id, is_mute)
#endregion
