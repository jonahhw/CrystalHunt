extends Node2D
class_name LevelBase

var crystals := []

func _ready() -> void:
	OS.set_window_size(Vector2(384, 384))	# Probably bad form, but idk how else to do it other than resizing all of the textures
	get_tree().call_group("crystals", "connect_to_level", self)
	yield(get_tree().create_timer(0.01), "timeout")
	pair_crystals()
	

func add_crystal(crystal: Node2D) -> void:
	if crystal.get_class() == "Crystal":
		crystals.append(crystal)
	else:
		print_debug("Something attempted to add a non-Crystal element to the crystals array")

func _on_Crystal_satisfied(crystal: Node2D) -> void:
	pass

func pair_crystals() -> void:
	var temp_crystals = crystals.duplicate()
	while (not temp_crystals.empty()):
		var crystal = temp_crystals.pop_back()
		for c in temp_crystals:
			if c.colour == crystal.colour:
				bind_crystals(c, crystal)
				temp_crystals.erase(c)
				break
		if !crystal._partner:
			print_debug("Could not find partner for ", crystal, " (", crystal.colour, ")")


func bind_crystals(c1: Node2D, c2: Node2D) -> void:
	if (c1.get_class() != "Crystal"):
		print_debug(c1, " is not a crystal, cannot bind")
		return
	if (c2.get_class() != "Crystal"):
		print_debug(c2, " is not a crystal, cannot bind")
		return
	c1.set_partner(c2)
	c2.set_partner(c1)
	
func reset() -> void:
	pass
