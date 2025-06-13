extends Node2D

@export var car_quantity: int = 0

@onready var car_asset: PackedScene = preload("uid://crwrfx45qslht")
@onready var car_skins: Resource = preload("uid://cc1gmfwqkcxxn")

var end_target_array: Array[Marker2D]
var path_array: Array[Node2D]
var target_array : Array


func _ready() -> void:
	initialize_paths()
	for i in car_quantity:
		# Crée un PNJ toutes les secondes, jusqu'au nombre de PNJ shouaité
		await get_tree().create_timer(5.0).timeout 
		initialize_pnj()

func initialize_paths() -> void:
	for i in self.get_children():
		path_array.append(i)

func initialize_pnj() -> void:
	randomize()
	var pnj_instance: CharacterBody2D = car_asset.instantiate()
	pnj_instance.manager = self
	
	var rand_path = path_array[randi_range(0, path_array.size() - 1)]
	
	target_array = rand_path.get_children()
	pnj_instance.position = target_array[0].position
	pnj_instance.spawn_point = pnj_instance.position
	pnj_instance.target_array = target_array
	pnj_instance.skin_texture = car_skins.sprites[randi_range(0, car_skins.sprites.size() - 1)]
	
	get_parent().call_deferred("add_child", pnj_instance)
