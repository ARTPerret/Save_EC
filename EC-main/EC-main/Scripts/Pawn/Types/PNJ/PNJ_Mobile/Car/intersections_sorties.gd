extends Node2D
class_name IntersectionSorties


func _on_sortie_area_entered(area: Area2D) -> void:
	if area.get_parent() is PNJCar:
		get_parent().get_node("Inter_Entrees").car_exit()
	


	
