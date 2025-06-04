extends Node2D

@export var pnj_quantity: int = 0
@export var max_dial_id: int

@onready var pnj_asset: PackedScene = preload("uid://bcny5exc06a15")
@onready var pnj_skins: Resource = preload("uid://c0i52vuytjc3a")

var path_target_array: Array[Vector2]
var spawn_target_array: Array[Vector2]

func _ready() -> void:
	initialize_paths()
	for i in pnj_quantity:
		# Crée un PNJ toutes les secondes, jusqu'au nombre de PNJ shouaité
		initialize_pnj()
		await get_tree().create_timer(1).timeout 

func initialize_paths() -> void:
	for i in $Middle_Targets.get_children():
		path_target_array.append(i.position)
	
	for i in $End_Targets.get_children():
		spawn_target_array.append(i.position)

func initialize_pnj() -> void:
	randomize()
	var pnj_instance: CharacterBody2D = pnj_asset.instantiate()
	
	pnj_instance.manager = self
	pnj_instance.position = spawn_target_array[randi_range(0, spawn_target_array.size() - 1)]
	pnj_instance.spawn_point = pnj_instance.position
	pnj_instance.skin_texture = pnj_skins.sprites[randi_range(0, pnj_skins.sprites.size() - 1)]
	pnj_instance.dial_id = randi_range(1,max_dial_id)
	
	get_parent().call_deferred("add_child", pnj_instance)
	
