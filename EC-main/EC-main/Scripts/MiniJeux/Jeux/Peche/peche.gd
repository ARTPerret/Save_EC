extends Control

@onready var spawnables = $Spawnables
@onready var spawnArea : CollisionShape2D = $SpawnArea 

@onready var spawnablesClouds = $CloudSpawnable
@onready var cloudSpawnArea = $CloudSpawnArea

# Chrono
var chrono = 30
# Temps d'apparition d'un item
var max_timer = 1
var timer = 0
# Compte le nombre d'item spawn
var counter = 0
# Fait spawn un short tous les X items
var short_apparition_time = 10
# Temps d'apparition d'un nuage
var cloudMax_Timer = 1.5
var cloudTimer = 0
# Coordonnées haute de la zone de spawn des items
var min_pos
# Hauteur de la zone de spawn
var hauteur_spawn
# Coordonnées haute de la zone de spawn des nuages
var min_cloud_pos
# Hauteur de la zone de spawn
var hauteur_spawn_cloud
# Pourcentage de poisson apparaissant
var fish_spawn_percent = 30

# Traque lorsque plusieurs dechets sont spawn en même temps, qu'il n'y ait pas de doublon.
var already_spawned = []

# Variable pour traquer le short
var short_spawn = false
var short_caught = false

func _ready() -> void:
	randomize()
	min_pos = spawnArea.position.y - spawnArea.shape.extents.y
	hauteur_spawn = spawnArea.shape.extents.y * 2
	min_cloud_pos = cloudSpawnArea.position.y - cloudSpawnArea.shape.extents.y
	hauteur_spawn_cloud = cloudSpawnArea.shape.extents.y * 2
	
	if SaveManager.getElement("Quests", "S_greg") == "found" or SaveManager.getElement("Quests", "S_greg") == "finished":
		short_caught = true
		get_parent().bookmark = 4


func _process(delta: float) -> void:
	timer -= delta
	cloudTimer -= delta
	chrono -= delta
	if timer <= 0:
		timer = max_timer
		spawn_multiple()
	if cloudTimer <= 0:
		cloudTimer = cloudMax_Timer
		spawn_cloud()
	if chrono < 0:
		get_parent().quit_minigame()
	else:
		update_chrono()

func update_chrono():
	var minutes = int(chrono) / 60
	var seconds = int(chrono) % 60
	var string_chrono = "%02d:%02d" % [minutes, seconds]
	$Label2.text = "Temps restant : " + string_chrono

func spawn_cloud() -> void:
	var pos
	var model = spawnablesClouds.get_child(randi_range(0,spawnablesClouds.get_child_count()-1))
	var clone : Node2D = model.duplicate()
	pos = randi_range(0, hauteur_spawn_cloud)
	clone.pos = Vector2(cloudSpawnArea.position.x, min_cloud_pos+pos)
	add_child(clone)
	clone.init()

func spawn_multiple() -> void:
	var nb_to_spawn = randi_range(1,3)
	already_spawned = []
	for i in range(nb_to_spawn):
		spawn()

func spawn():
	var model # objet qu'on va cloner
	var pos # où il va apparaitre
	# Augmentation du compteur de nombre d'objet spawn
	counter += 1
	
	model = choose_model()

	if model.name == "Short":
		short_spawn = true


	var clone : Node2D = model.duplicate()
	if model.name == "Velo": # Les velos spawnent tous le temps à la valeur la plus basse
		pos = hauteur_spawn
	else:
		pos = randi_range(0, hauteur_spawn)
	
	# Ajout de l'item à la scène
	clone.type = model.name
	clone.pos = Vector2(spawnArea.position.x, min_pos+pos)
	add_child(clone)
	clone.init()

func choose_model(): # Choose what to spawn
	# Check si on fait spawn un short
	var model
	var good_model = false
	while not good_model:
		if counter % short_apparition_time == 0 and not short_caught and not short_spawn:
			return $Short
		else:
			var rand_number = randi_range(0,99)
			if rand_number <= fish_spawn_percent:
				model = $Spawnables/Poisson
			else:
				model = $Spawnables/Dechets.get_child(randi_range(0,$Spawnables/Dechets.get_child_count()-1))
		
		good_model = not already_spawned.has(model.name)
	already_spawned.append(model.name)
	return model
