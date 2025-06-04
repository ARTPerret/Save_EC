extends AudioPool
class_name SoundEffects

# Utiliser pour jouer des sfx
func play(resource: AudioStreamWAV, volume: float = 0.0) -> void:
	var player: AudioStreamPlayer = select_player(resource)
	player.volume_db = volume
	player.call_deferred("play")

# Utiliser pour arrêter tout les sfx
func stop() -> void:
	for player in audio_players:
		player.stream = null
