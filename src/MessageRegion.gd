extends Area2D

signal send_message(message)

export var message: String

func _on_MessageRegion_body_entered(body: Node) -> void:
	if body.get_class() == "Player":
		emit_signal("send_message", message)

