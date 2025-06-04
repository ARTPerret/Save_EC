extends Node2D
class_name AudioPool

var audio_players: Array[AudioStreamPlayer] = []

# Met en place les pools Audio
func _init(audio_bus: String, pool_size : int) -> void:
	for i in pool_size:
		var player: AudioStreamPlayer = AudioStreamPlayer.new()
		player.process_mode = PROCESS_MODE_ALWAYS
		add_child(player)
		audio_players.append(player)
		player.bus = audio_bus
		player.finished.connect(on_player_finished.bind(player))

# Selectionne un player non utilisé ou le plus ancien si aucun est disponible
func select_player(resource: AudioStream) -> AudioStreamPlayer:
	for i in audio_players:
		if !i.has_stream_playback() :
			i.stream = resource
			audio_players.append(i)
			audio_players.erase(i)
			return audio_players.back()
	var front_player: AudioStreamPlayer = audio_players.front()
	front_player.stream = resource
	audio_players.append(front_player)
	audio_players.erase(front_player)
	return audio_players.back()

func on_player_finished(player: AudioStreamPlayer) -> void:
	player.stream = null
