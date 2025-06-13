class_name Dechet

extends CharacterBody2D

var speed = 300
var rotate = 0
var clockwise = false
var clone = false

var magnetted : bool = false
var short : bool = false # est un short.

var dead_fish = false


var type
var weight = 0
var pos : Vector2

func init() -> void:
	collision_mask = 12 # masques 3 et 4, pour le sol et l'area de l'aimant
	position = pos
	if get_parent().name == "Spawnables":
		visible = false
	else:
		clone = true
		visible = true
		match type:
			"Poisson":
				speed += randi_range(speed/10, speed/2)
				setcolor()
			"Cola":
				weight = 1
				speed += randi_range(speed/10, speed/2)
				setrotation()
			"Peps":
				weight = 1
				speed += randi_range(speed/10, speed/2)
				setrotation()
			"Velo":
				weight = 5
				setcolor()
			"Short":
				weight = 1
				setrotation()
				short = true
				
			
func setcolor() -> void:
	$Couleur.modulate = Color(randf(), randf(), randf(), 1.0)

func setrotation() -> void:
	rotate = randf_range(0.01,0.05)
	clockwise = randi_range(0,1) == 1

func magnetized():
	magnetted = true

func unmagnetized():
	magnetted = false
	collision_layer = 2 # masques 3 et 4, pour le sol et l'area de l'aimant

func _physics_process(delta: float) -> void:
	if magnetted:
		if type == "Poisson":
			if dead_fish:
				velocity.y = 100 * delta
				velocity.x = 0
				var collision = move_and_collide(velocity)
				if collision: # Il peut toucher que le sol du coup
					queue_free()
			else:
				dead_fish = true
				$Squelette.visible = false
				$SqueletteMort.visible = true
				$SqueletteMort.flip_v = true
				$Couleur.flip_v = true
				$Couleur.modulate = Color(0.8,0.8,0.8,1.0)
				collision_mask = 4 # on retire la collision avec l'aimant
				collision_layer = 32 # layer 6, poisson mort
				get_parent().get_node("Aimant").fish_dead()
			
			
		return
		
	if clone:
		velocity.x = -speed * delta
		velocity.y = 0
		if clockwise:
			rotation += rotate
		else:
			rotation -= rotate
		
		if position.x < -200:
			queue_free()
			if short:
				get_parent().short_spawn = false
		
	move_and_collide(velocity)
