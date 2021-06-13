extends KinematicBody2D
class_name Player

export var speed: float = 96

onready var level: LevelBase = get_parent()

var trail_mode: bool = false
var following_crystal = null
var path_trails := []
onready var trail_scene: PackedScene = preload("res://src/Trail.tscn")

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
		_toggle_trail()
	if event.is_action_pressed("reset"):
		level.reset()
	

func _toggle_trail() -> void:
#	print_debug("Toggle trail: trail was ", trail_mode)
	if trail_mode:
		cancel_trail()
		return
	var potential_crystal_areas = $CrystalDetector.get_overlapping_areas()
	var crystals := []
	for crA in potential_crystal_areas:
		if crA.get_parent().get_class() == "Crystal":
			crystals.append(crA.get_parent())
#	print_debug("found ", potential_crystal_areas.size(), " potential crystals and ", crystals.size(), " crystals")
	match crystals.size():
		0:
			return
		1:
			following_crystal = crystals[0]
			trail_mode = true
		_:
			var min_dist: float = float("1e100")	# Start trail on the closest crystal
			var min_crystal: Crystal
			for cr in crystals:
				var current_dist: float = (cr.position - position).length()
				if current_dist < min_dist:
					min_dist = current_dist
					min_crystal = cr
			following_crystal = min_crystal
			trail_mode = true
	add_new_trail()

func find_nearest_tile() -> Vector2:
	var out: Vector2 = position/32
	out.x = floor(out.x) + 0.5
	out.y = floor(out.y) + 0.5
	return out * 32

func add_new_trail():
	var new_trail := trail_scene.instance()
	level.add_child(new_trail)
#	print_debug("Placing a trail at ", find_nearest_tile(), "; scene is of class ", new_trail.get_class(), " and will be ", following_crystal.colour)
	new_trail.position = find_nearest_tile()
	new_trail.colour = following_crystal.colour
	new_trail.connect("player_exited", self, "_on_Trail_player_exited")
	new_trail.connect("ran_into_trail", self, "_on_Trail_ran_into_trail")
	new_trail.connect("trail_hit_crystal", self, "_on_Trail_hit_crystal")
	path_trails.push_back(new_trail)

func cancel_trail() -> void:
#	print_debug("removing array")
	for trail in path_trails:
		trail.destroy()
	path_trails = []
	trail_mode = false

func _on_Trail_player_exited(trail: Trail):
	if path_trails.has(trail):
		add_new_trail()

func _on_Trail_ran_into_trail(announcing_trail: Trail, existing_trail: Trail):
	# remove all trails after existing_trail
	for i in path_trails.size():
		if path_trails[i] == existing_trail:
			for j in range(i+1, path_trails.size()):
				path_trails[i].delete()
				path_trails.remove(i)
			return
	cancel_trail()		# If existing_trail is not in the current path

func _on_Trail_hit_crystal(trail: Trail, crystal: Crystal) -> void:
	if (crystal._partner == following_crystal):
		handle_trail_connect()
	elif (crystal == following_crystal):
		# delete all trails except for the first
		for i in range(1, path_trails.size()):
			path_trails[i].delete()
			path_trails.remove(i)
	else:
		cancel_trail()

func handle_trail_connect() -> void:
	pass

func get_class() -> String:
	return "Player"
	
func display_message(message: String) -> void:
	$Message.visible = true
	$Message.text = message
	$Message/Timer.start()
	yield($Message/Timer, "timeout")
	$Message.text = ""
	$Message.visible = false
