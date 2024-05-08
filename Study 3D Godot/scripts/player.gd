extends CharacterBody3D
class_name Player

@onready var _head := get_node("Head")

var _normal_speed := 3.0
var _sprint_speed := 5.0
var _speed := 3.0
var _jump_velocity := 4.0
var _gravity := 0.2
var _mouse_sensitivity := 0.002

func _input(event : InputEvent):
	if event is InputEventMouseMotion:
		_look_around(event.relative)

func _unhandled_key_input(event : InputEvent):
	if event.is_action_pressed("escape"):
		get_tree().quit()

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(_delta : float) -> void:
	_move()

func _look_around(relative : Vector2) -> void:
	rotate_y(-relative.x * _mouse_sensitivity)
	_head.rotate_x(-relative.y * _mouse_sensitivity)
	_head.rotation_degrees.x = clampf(_head.rotation_degrees.x, -90, 90)

func _move() -> void:
	if not is_on_floor():
		velocity.y -= _gravity
	elif Input.is_action_just_pressed("jump"):
		velocity.y = _jump_velocity
	else:
		_speed = _sprint_speed if Input.is_action_pressed("sprint") else _normal_speed
	
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y))
	
	velocity.x = direction.x * _speed
	velocity.z = direction.z * _speed
	
	move_and_slide()
