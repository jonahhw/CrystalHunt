extends AnimatedSprite
class_name Trail

signal player_exited(trail)
signal ran_into_trail(announcing_trail, existing_trail)
signal trail_success(trail, crystal)

var colour: String

func _ready() -> void:
	var area_list = $Area2D.get_overlapping_areas()
	for area in area_list:
		var area_parent = area.get_parent()
		if area_parent.get_class == "Crystal":
			handle_crystal(area_parent)
		elif area_parent.get_class == "Trail":
			handle_trail(area_parent)
		else:
			print_debug("Weird collision stuff happening")
	yield(get_tree().create_timer(0.01), "timeout")
	play(colour)
	print_debug("I exist now, of colour ", colour, " and position ", position, ".")

func _on_Area2D_body_exited(body: Node) -> void:
	print_debug("body exited")
	if body.get_class() == "Player":
		emit_signal("player_exited", self)

func handle_crystal(c: Crystal) -> void:
	pass

func handle_trail(trail) -> void:
	emit_signal("ran_into_trail", self, trail)

func destroy() -> void:
	print_debug("I died")
	queue_free()


func get_class() -> String:
	return "Trail"

func VibeCheck() -> void:
	print_debug("I still exist (still colour ", colour, " and position ", position, ").")
