extends Node2D

func _on_break_area_entered(area_id, area, area_shape, self_shape):
	if area.is_in_group("breaker"):
		queue_free()
