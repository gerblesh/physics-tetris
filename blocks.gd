extends Node3D

var block_array = [
	preload("res://Pieces/line.tscn"),
	preload("res://Pieces/L.tscn"),
	preload("res://Pieces/S.tscn"),
	preload("res://Pieces/square.tscn"),
	preload("res://Pieces/wither.tscn")
]
var color_array = [
	Color(1,1,0),
	Color(0,1,0),
	Color(0,0,1)
]
var current = 0
var next = 0
var current_piece: RigidDynamicBody3D
var move_speed = 30
var rotation_speed = 10
var y_speed = 14

func _ready():
	_next()

# moving to next piece
func _next():
	current = next
	# randomizing piece
	randomize()
	next = randi() % 5
	instance_piece()

func instance_piece():
	current_piece = block_array[current].instantiate()
	# piece properties
	current_piece.position = position
	current_piece.mass = 0.2
	current_piece.contact_monitor = true
	current_piece.set_max_contacts_reported(1)
	# setting color
	var rand_color = color_array[randi() % 3]
	current_piece.get_node("mesh").get_surface_override_material(0).albedo_color = rand_color
	# await because for some reason godot cringe
	await get_tree().process_frame
	get_parent().add_child(current_piece)
# piece update
func _physics_process(delta):
	# checking for when to release the piece
	if Input.is_action_just_pressed("release") or current_piece.get_colliding_bodies().size() > 0:
		return await release_piece()
	# left right movement axis
	var linear_axis = Input.get_action_strength("left") - Input.get_action_strength("right")
	# up down movement axis
	var rotation_axis = Input.get_action_strength("rotate_left") - Input.get_action_strength("rotate_right")
	# moving the piece
	current_piece.linear_velocity.y = -y_speed
	current_piece.linear_velocity.z = linear_axis * move_speed
	current_piece.angular_velocity.x = rotation_axis * rotation_speed

# releasing the piece
func release_piece():
	set_physics_process(false)
	$moaning.play()
	current_piece = null
	# waiting to reinstance another piece
	await get_tree().create_timer(0.7,false).timeout
	_next()
	set_physics_process(true)
