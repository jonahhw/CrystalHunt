extends KinematicBody2D

export var speed: float = 96

var trail_mode: bool = false
var following_crystal = null
var child_trails := []

func _physics_process(delta: float) -> void:
	var direction := Vector2.ZERO
	if (OS.is_window_focused()):
		direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	if (direction.length() > 0):
		direction = direction.normalized()
	
	move_and_slide(direction*speed)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("crystal_mode"):
		_start_connecting_crystals()
	

func _start_connecting_crystals() -> void:
	if trail_mode:
		for trail in child_trails:
			trail.destroy()
		return
	var potential_crystals = $CrystalDetector.get_overlapping_areas()
	var crystals := []
	for cr in potential_crystals:
		if cr.get_class() == "Crystal":
			crystals.append(cr)
	match crystals.size():
		0:
			return
		1:
			following_crystal = crystals[0]
			trail_mode = true
		_:
			pass
	
