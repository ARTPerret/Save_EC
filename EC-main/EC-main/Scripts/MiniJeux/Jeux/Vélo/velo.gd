extends Control

var actions_needed: int = 0
var actions_completed: int = 0

func _ready() -> void:
	_initialize_anchors()
	_initialize_panels()

func _initialize_anchors() -> void:
	for i in $Anchors.get_children():
		if i.piece_is_on == false:
			actions_needed += 1
		if i.is_fixed == false:
			actions_needed += 1
		if i.anchor_id == 0:
			i.visible = true
			i.get_node("CollisionShape2D").disabled = false

func _initialize_panels() -> void:
	for i in $PanelPieces.get_children():
		i.minigame_window = self
		i.initialize_piece()
	for i in $PanelOutils.get_children():
		i.minigame_window = self
		i.initialize_outil()

func add_action() -> void:
	actions_completed += 1
	
	#change l'ancre interagisable quand le joueur a fini ses réparations.
	if actions_completed == 1:
		change_anchor(0)
	
	if actions_completed == 5:
		change_anchor(1)
	
	if actions_completed == 7:
		change_anchor(2)
		
		
	if actions_completed >= actions_needed:
		await get_tree().create_timer(2.0).timeout
		get_parent().quit_minigame()
		
		
func change_anchor(id: int) -> void:
	for i in $Anchors.get_children():
			if i.anchor_id == id:
				i.visible = false
				i.get_node("CollisionShape2D").disabled = true
			if i.anchor_id == id + 1:
				i.visible = true
				i.get_node("CollisionShape2D").disabled = false
