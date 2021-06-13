extends Node2D
class_name Crystal

signal satisfied(crystal)

var _partner: Crystal
export var colour: String
var is_satisfied: bool = false

func connect_to_level(level: LevelBase) -> void:
	level.add_crystal(self)

func _ready() -> void:
	$AnimatedSprite.play(colour)

func on_connected() -> void:
	is_satisfied = true
	emit_signal("satisfied", self)
	$Area2D.set_collision_layer(0)
	$Area2D.set_collision_mask(0)
	

func set_partner(potential_partner: Crystal) -> void:
	if potential_partner.get_class() == self.get_class():
		if potential_partner.colour == self.colour:
			if _partner:
				potential_partner.connect("death", self, "_on_Mob_death")
			_partner = potential_partner
		else:
			print_debug("Something attempted to set a partner of the wrong colour")
	else:
		print_debug("Something attempted to set a non-Crystal partner")
		

func get_class() -> String:
	return "Crystal"
