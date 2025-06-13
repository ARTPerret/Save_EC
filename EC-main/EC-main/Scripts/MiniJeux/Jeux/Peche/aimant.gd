extends CharacterBody2D

@onready var ligne : Line2D = get_parent().get_node("Line2D")
@onready var offset = ($Sprite.texture.get_size().y * $Sprite.scale.y) / 2
@onready var score_label = get_parent().get_node("Label")

var monter : bool = false
var puissance : int = 300
var max_height : int = 0

var magnet_bodies = []
var max_weight = 8

var score = 0

@onready var fixX = position.x

func _ready() -> void:
	max_height = position.y

func get_weight() -> int:
	var w = 0
	for body in magnet_bodies:
		w += body.weight
	return w

func _process(delta: float) -> void:
	ligne.remove_point(1)
	ligne.add_point(Vector2(position.x, $Sprite.global_position.y - offset))
	
	monter = Input.is_action_pressed("interact")
	for body in magnet_bodies:
		body.position = $Area2D.global_position
	
	
	# Poisson touché aie aie aie
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if collision.get_collider() is Dechet:
			collision.get_collider().magnetized()
			for mbody in magnet_bodies:
				mbody.unmagnetized()
			magnet_bodies = []
			update_score()


func _on_area_2d_body_entered(body: Dechet) -> void:
	if body.weight + get_weight() <= max_weight:
		body.magnetized()
		magnet_bodies.append(body)

func _physics_process(delta: float) -> void:
	if monter:
		velocity.y -= puissance*delta
	else:
		velocity.y += puissance*delta
	
	if position.y < max_height:
		position.y = max_height
		velocity.y = 0
		
		
		if len(magnet_bodies) != 0:
			var score_addition = 0
			for body in magnet_bodies:
				score_addition += body.weight
				if body.type == "Short":
					# C'est là où y a le script peche.gd
					get_parent().short_caught = true
					get_parent().get_parent().bookmark = 2
					get_parent().short_spawn = false
					score_addition += 9 # Le short vaut donc 10 points
				body.queue_free()
			score += score_addition
			magnet_bodies = []
			update_score()
	
	velocity.x = 0
	position.x = fixX
	move_and_slide()

func fish_dead():
	score -= 5
	update_score()

func update_score():
	if score < 0:
		score = 0
	score_label.text = "Score : " + str(score)
	
