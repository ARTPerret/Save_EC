extends Node2D
class_name IntersectionEntrees

var nb_cars: int = 0
var array_cars_waiting: Array

func update_id_cars():
	if !array_cars_waiting.is_empty():
		for i in array_cars_waiting:
			i.id_in_queue -= 1
			if i.id_in_queue == 0:
				i.state_machine.change_state("Pathfinding")
			
		array_cars_waiting.remove_at(0)


func update_nb_car_wainting(car: Node2D) -> void:
	array_cars_waiting.push_back(car)
	
func car_exit():
	update_id_cars()
	nb_cars -= 1


func _on_entree_area_entered(area: Area2D) -> void:
	print(nb_cars)
	if area.get_parent() is PNJCar:
		#print (nb_cars)
		if nb_cars == 0: 
			nb_cars += 1
		else :
			area.get_parent().state_machine.change_state("Regular")
			area.get_parent().id_in_queue = nb_cars
			nb_cars += 1
			update_nb_car_wainting(area.get_parent())
