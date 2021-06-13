extends Area2D

var is_active: bool = false
signal not_ready(message)

export var scene_to_load: String
export var not_ready_message: String = "Connect all of the crystals first"

func _on_ExitRegion_body_entered(body: Node) -> void:
	if body.get_class() == "Player":
		if is_active:
			get_tree().change_scene(scene_to_load)
		else:
			emit_signal("not_ready", not_ready_message)

func set_is_active(input: bool) -> void:
	is_active = input
