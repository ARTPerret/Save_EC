extends Resource
class_name GradeBlockVariables

@export var title: String

@export var category: String

@export_multiline var description: String
@export_multiline var description_scientifique: String

@export_group("MissionSaveKeys") # Vérifie si la mission s'est déroulé
@export var mission_key_1: String
@export var mission_key_2: String

@export_group("MissionPointsSaveKeys") # Regarde le score de la mission
@export var point_key_1: String
@export var point_key_2: String
