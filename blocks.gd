extends Node3D

var block_array = [
	preload("res://Pieces/line.tscn"),
	preload("res://Pieces/L.tscn"),
	preload("res://Pieces/S.tscn"),
	preload("res://Pieces/square.tscn"),
	preload("res://Pieces/wither.tscn")
]

var current = 0
var next = 0
var current_piece: RigidDynamicBody3D
var move_speed = 30

func _ready():
	_next()

func _next():
	current = next
	randomize()
	next = randi() % 5
	current_piece = block_array[current].instantiate()
	current_piece.position = position
	current_piece.mass = 0.2
	current_piece.contact_monitor = true
	await get_tree().process_frame
	get_parent().add_child(current_piece)

func _physics_process(delta):
	var linear_axis = Input.get_action_strength("left") - Input.get_action_strength("right")
	var rotation_axis = Input.get_action_strength("rotate_right") - Input.get_action_strength("rotate_left")
	current_piece.linear_velocity.y = -7
	current_piece.linear_velocity.z = linear_axis * move_speed
	current_piece.angular_velocity.x = rotation_axis * -10
	if Input.is_action_just_pressed("release") or current_piece.get_colliding_bodies().size() > 0:
		release_piece()

func release_piece():
	set_physics_process(false)
	current_piece = null
	await get_tree().create_timer(0.3,false).timeout
	_next()
	set_physics_process(true)
