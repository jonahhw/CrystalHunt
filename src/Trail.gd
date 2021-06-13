extends AnimatedSprite
class_name Trail

signal player_exited(trail)
signal ran_into_trail(announcing_trail, existing_trail)
signal trail_hit_crystal(trail, crystal)

var colour: String

func _ready() -> void:
	yield(get_tree().create_timer(0.01), "timeout")
	var area_list = $Area2D.get_overlapping_areas()
	for area in area_list:
		var area_parent = area.get_parent()
		if area_parent.get_class == "Crystal":
			handle_crystal(area_parent)
		elif area_parent.get_class == "Trail":
			handle_trail(area_parent)
		else:
			print_debug("Weird collision stuff happening")
	play(colour)
#	print_debug("I exist now, of colour ", colour, " and position ", position, ".")

func _on_Area2D_body_exited(body: Node) -> void:
	if body.get_class() == "Player":
		emit_signal("player_exited", self)

func handle_crystal(crystal: Crystal) -> void:
	emit_signal("trail_hit_crystal", self, crystal)

func handle_trail(trail) -> void:
	print_debug("Crystal_detected")
	emit_signal("ran_into_trail", self, trail)

func destroy() -> void:
	print_debug("I died")
	queue_free()


func get_class() -> String:
	return "Trail"
