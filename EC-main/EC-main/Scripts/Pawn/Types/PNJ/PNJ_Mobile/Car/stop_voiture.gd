extends Area2D

func _on_area_entered(area):
	if area.get_parent() is PNJCar:
		area.get_parent().stop_car()
