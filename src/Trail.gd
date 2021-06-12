extends AnimatedSprite


func _ready() -> void:
	var area_list = $Area2D.get_overlapping_areas()
	for area in area_list:
		if area.get_parent().get_class == "Crystal":
			handle_crystal(area.get_parent())
		elif area.get_parent().get_class == "Trail":
			handle_trail(area)
		else:
			print_debug("Weird collision stuff happening")
	

func handle_crystal(c: Crystal) -> void:
	pass

func handle_trail(area) -> void:
	pass

func get_class() -> String:
	return "Trail"

func destroy() -> void:
	queue_free()
