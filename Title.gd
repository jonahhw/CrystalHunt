extends CanvasLayer

func _ready() -> void:
	OS.set_window_size(Vector2(512, 512))	# Probably bad form, but idk how else to do it other than resizing all of the textures

func _on_PlayButton_pressed() -> void:
	get_tree().change_scene("res://src/Level0.tscn")
