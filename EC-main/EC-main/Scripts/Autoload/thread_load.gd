extends Node2D

var viewport: SubViewport

@onready var loading_screen: PackedScene = preload("uid://dncr4ks587ty3") 
@onready  var maps: Resource = preload("uid://byrvrkqe18ml0")

func initialize_viewport(game_viewport: SubViewport) -> void:
	viewport = game_viewport

func load_scene(next_scene: String, pos_id: int = 0, loading_screen_type: String = "") -> void:
	Dialogic.end_timeline()
	
	FadeManager.trigger_fade(1, 0.25, 3)
	AudioManager.fade_music(-80, 0.5)
	await FadeManager.tween.finished
	
	_erase_scenes()
	
	# Créer la scène de chargement
	var loading_instance: Node2D = loading_screen.instantiate()
	loading_instance.loading_screen_key = loading_screen_type # Envoie la clée pour selectionner l'écran de chargement
	viewport.call_deferred("add_child", loading_instance)
	
	ResourceLoader.load_threaded_request(maps.locations[next_scene], "", true)
	
	var progress: Array = []
	while true:
		match ResourceLoader.load_threaded_get_status(maps.locations[next_scene], progress):
			0:
				print("Error, invalid scene")
				return
			3:
				var scene: Node2D = ResourceLoader.load_threaded_get(maps.locations[next_scene]).instantiate()
				
				# Pour éviter les problèmes si on crée une scène sans joueur (ex: menu, leaderboard)
				scene.start_id = pos_id
				if scene is Map:
					SaveManager.setElement("Player", {"scene": next_scene})
					SaveManager.setElement("Player", {"pos": pos_id})
					SaveManager.save()
				
				loading_instance.next_scene = scene
				return

func trigger_next_scene(target_scene: Node2D) -> void:
	_erase_scenes()
	viewport.call_deferred("add_child", target_scene)

func _erase_scenes() -> void:
	# Supprime les scènes contenu dans le viewport (écran de chargement, scène précédente)
	for prev_scene in viewport.get_children():
		prev_scene.queue_free()
