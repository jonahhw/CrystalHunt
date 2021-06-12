extends Node2D
class_name Crystal

var _partner: Crystal
export var colour: String

func _ready() -> void:
	$AnimatedSprite.play(colour)

func connect_to_level(level: LevelBase) -> void:
	level.add_crystal(self)
	connect("satisfied", level, "_on_Crystal_satisfied")

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
