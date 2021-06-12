extends LevelBase

var crystals := []

func _ready() -> void:
	get_tree().call_group("crystals", "connect_to_level", self)
	yield(get_tree().create_timer(0.01), "timeout")
	print(crystals)

func add_crystal(crystal: Node2D) -> void:
	if crystal.get_class() == "Crystal":
		crystals.append(crystal)
	else:
		print_debug("Something attempted to add a non-Crystal element to the crystals array")

func _on_Crystal_satisfied(crystal: Node2D):
	pass
