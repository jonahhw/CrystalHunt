extends LevelBase

func _ready() -> void:
	OS.set_window_size(Vector2(384, 384))	# Probably bad form, but idk how else to do it other than resizing all of the textures
