extends CharacterBody3D
class_name Player

@onready var _head : Node3D = get_node("Head")
@onready var _ray_cast_3D : RayCast3D = get_node("Head/RayCast3D")
@onready var _label : Label = get_node("HUD/Label")

var _base_speed : float = 3.0
var _sprint_speed : float = 5.0
var _speed : float = 3.0
var _jump_velocity : float = 6.0
var _gravity : float = 0.2
var _mouse_sensitivity : float = 0.002

func _input(event : InputEvent) -> void:
	if event is InputEventMouseMotion:
		_look_around(event.relative)

func _process(_delta : float) -> void:
	_check_interaction()

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
		_speed = _sprint_speed if Input.is_action_pressed("sprint") else _base_speed
	
	var input_dir : Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction : Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	velocity.x = direction.x * _speed
	velocity.z = direction.z * _speed
	
	move_and_slide()

func _check_interaction() -> void:
	if _ray_cast_3D.is_colliding():
		var object = _ray_cast_3D.get_collider()
		_label.text = object.get_object_type()
		if Input.is_action_just_pressed("interact"):
			object.queue_free()
	else:
		_label.text = ""
