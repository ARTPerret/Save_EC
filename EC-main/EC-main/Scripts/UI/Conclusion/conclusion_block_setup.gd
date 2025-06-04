extends Control

@export var target: Control
@export var category_order: Array[String]
@export var block_data: GradeBlockList

var follower_count: float = 0
var score: float = 0

@onready var title_panel: Label = $Margin/VBox/TitlePanel/VBox/ChapterLabel
@onready var category_label: PackedScene = preload("uid://c568qfvjhr3hp")
@onready var mission_block: PackedScene = preload("uid://b1c44utdyam2d")
@onready var empty_block: PackedScene = preload("uid://c6kvwb2oslbg1")
@onready var note_label: Label = $Margin/VBox/EndPanel/VBox/NoteHBox/GradeLabel
@onready var fol_img: CompressedTexture2D = preload("uid://bxlgsb6fsifr8")

func _ready() -> void:
	_initialize_content()
	_initialize_score()

func _initialize_categories() -> Dictionary[String,Array]:
	var summary_content: Dictionary[String,Array]
	var block_data_list: Array
	for data in block_data.blocks:
		block_data_list.append(load(block_data.blocks[data]))
	
	# setup category list
	for block in block_data_list:
		summary_content[block.category] = []
	
	# load shit into dictionnary
	for block in block_data_list:
		for category in summary_content:
			if block.category == category:
				summary_content[category].append(block)
	
	return summary_content

func _initialize_content() -> void:
	var summary_content: Dictionary[String,Array] = _initialize_categories()
	
	for category in category_order:
		var category_size: int = 0
		var new_category: Label = category_label.instantiate()
		new_category.text = category
		
		target.add_child(new_category)
		
		for summary in summary_content[category]:
			var save_mission: Variant = SaveManager.getElement(summary.mission_key_1, summary.mission_key_2)
			if save_mission == null:
				continue # Si la mission n'est pas faite skip
			
			var save_score: float = 0.0
			if SaveManager.getElement(summary.point_key_1, summary.point_key_2):
				save_score = SaveManager.getElement(summary.point_key_1, summary.point_key_2)
			
			var new_summary: PanelContainer = mission_block.instantiate()
			var summary_label: Label = new_summary.get_node(new_summary.get_meta("topic_path"))
			var desc_text: RichTextLabel = new_summary.get_node(new_summary.get_meta("desc_path"))
			var source_text: RichTextLabel = new_summary.get_node(new_summary.get_meta("source_path"))
			var score_text: Label = new_summary.get_node(new_summary.get_meta("score_path"))
			
			summary_label.text = summary.title
			desc_text.text = summary.description
			source_text.text = summary.description_scientifique
			
			if category == "Followers":
				var type_img: TextureRect = new_summary.get_node(new_summary.get_meta("type_path"))
				type_img.texture = fol_img
				
				score_text.text = str(int(save_score))
				# score positif vert, negatif rouge
				if save_score > 0:
					score_text.text = "+" + score_text.text
					score_text.label_settings.font_color = Color.GREEN
				else:
					score_text.label_settings.font_color = Color(0.427,0.427,0.427)
				
				follower_count += save_score
			else:
				save_score = save_score * 2 # TEMPORARIRE POUR GGS
				score_text.text = str(save_score)
				# score positif rouge, negatif vert (EcoScore réduire empreinte)
				if save_score > 0:
					score_text.text = "+" + score_text.text
					score_text.label_settings.font_color = Color.RED
				elif save_score < 0:
					score_text.label_settings.font_color = Color.GREEN
				
				score += save_score
			
			target.add_child(new_summary)
			category_size += 1
		
		if category_size == 0:
			var new_empty: PanelContainer = empty_block.instantiate()
			target.add_child(new_empty)

func _initialize_score() -> void:
	var total_score: float = score - (follower_count / 4)
	var final_score: int = 0
	
	if total_score < 0:
		final_score= ceil((score / -0.77) + floor(follower_count/4))
	else:
		final_score= floor((score / -0.65) + floor(follower_count/4))
	
	match final_score:
		-8: note_label.text = "F"
		-7: note_label.text = "E-"
		-6: note_label.text = "E"
		-5: note_label.text = "E+"
		-4: note_label.text = "D-"
		-3: note_label.text = "D"
		-2: note_label.text = "D+"
		-1: note_label.text = "C-"
		0: note_label.text = "C"
		1: note_label.text = "C+"
		2: note_label.text = "B-"
		3: note_label.text = "B"
		4: note_label.text = "B+"
		5: note_label.text = "A-"
		6: note_label.text = "A"
		7: note_label.text = "A+"
		8: note_label.text = "S"
		_: note_label.text = "F"

func _on_quit_button_pressed() -> void:
	SaveManager.deleteSave()
	EventBus.emit_signal("clear_items")
	EventBus.emit_signal("clean_quests")
	EventBus.emit_signal("reset_time")
	ThreadLoad.load_scene("Journalistes")
